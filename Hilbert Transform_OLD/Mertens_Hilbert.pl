#####################
# phase_osc_hilbert #
#####################

use PDL::NiceSlice;
use PDL::FFT;
use PDL::Fit::Householder;

sub find_first_crossing_preidx {
     my ($ys, $dir, $start_idx, $stop_idx, $value_to_cross) = @_;
     $start_idx = int($start_idx);
     $stop_idx = int($stop_idx);
     $value_to_cross ||= 0;
     $ys = $ys($start_idx:$stop_idx);
     my $indices;
     if ($dir > 0) {
         $indices = which(
             ($ys(:-2) < $value_to_cross)  # left point is below
         &   ($ys(1:) >= $value_to_cross)  # right point is above
         );
     }
     else {
         $indices = which(
             ($ys(:-2) >= $value_to_cross)  # left point is above
         &   ($ys(1:)  <  $value_to_cross)  # right point is below
         );
     }
     confess("Could not find any zero crossings between $start_idx and 
$stop_idx")
         if $indices->nelem == 0;
     my $to_return = $indices->at(0) + $start_idx;
     return $to_return;
}

# Code from 
http://stackoverflow.com/questions/717762/how-to-calculate-the-vertex-of-a-parabola-given-three-points
# modified and simplified for uniform x-spacing. X-values are taken to
# be at -1, 0, and 1.
sub find_vertex {
     my ($y) = @_;
     my $A     = (2*$y->at(1) - $y->at(0) - $y->at(2)) / 2;
     my $B     = ($y->at(0) - $y->at(2)) / 2;
     my $C     = -$y->at(1);
     return (-$B / (2*$A), -$C + $B*$B / (4*$A));
}

sub find_min {
     my ($ys, $start_idx, $stop_idx) = @_;
     my $min_idx = $ys($start_idx:$stop_idx)->minimum_ind->at(0) + 
$start_idx;
     my ($dx, $min_y) = find_vertex($ys($min_idx - 1 : $min_idx + 1));
     return ($min_y, $min_idx + $dx);
}
sub find_max {
     my ($ys, $start_idx, $stop_idx) = @_;
     my $max_idx = $ys($start_idx:$stop_idx)->maximum_ind->at(0) + 
$start_idx;
     my ($dx, $max_y) = find_vertex($ys($max_idx - 1 : $max_idx + 1));
     return ($max_y, $max_idx + $dx);
}

sub correct_ys {
     my ($ys, $imag, $l_idx, $l_mean, $l_amp, $r_idx, $r_mean, $r_amp) = @_;

     # Correct the y-values from the left to the middle
     $l_idx++ if $l_idx == int($l_idx);
     my $values = $ys($l_idx:$r_idx);
     my $n = $values->nelem;
     my $means = $l_mean + sequence($n) * ($r_mean - $l_mean) / ($n - 1);
     $values -= $means;
     my $amps = $l_amp + sequence($n) * ($r_amp - $l_amp) / ($n - 1);
     $values /= $amps;

     my $local_imag = $imag($l_idx:$r_idx);
     $local_imag .= sqrt(1 - $values**2);

     # Note: there will be annoying interpolation issues when there are
     # multiple points that have the same magnitude as the max. In that 
     # case,
     # it can happen that the "normalized" value is now greater than 1. To
     # address this, set the $value to 1 and the imag to zero:
     $local_imag->where(abs($values) > 1) .= 0;
     $values->where($values > 1) .= 1;
     $values->where($values < -1) .= -1;
}

sub smooth_imag {
     my ($imag, $left_idx, $right_idx) = @_;
     my $to_fit = $imag($left_idx:$right_idx);

     # Fit the imaginary data to a parabola
     my $t = $to_fit->sequence / $to_fit->nelem;
     my $coefs = $to_fit->Householder(2, $t);

     # Get the parabolic form and deviations from it
     my $fit = $coefs(0) + $coefs(1) * $t + $coefs(2) * $t**2;
     my $dev = $to_fit - $fit;

     # Squash the deviations
     my $weight = $to_fit->xlinvals(-0.5, 0.5)->abs;
     $to_fit .= $fit + $dev * $weight;
}

sub phase_osc_hilbert {
     my ($ys) = @_;

     croak('Must provide ys as a piddle') unless $ys->isa('PDL');
     my $xs = $ys->sequence * dt;
     my $real = $ys->copy;
     my $imag = $ys->zeros;

     # Use the FFT to figure out an approximate period (in units of time 
     #$steps)
     my $period_idx;
     {
         my $amp = $real->copy;
         my $N = $amp->nelem;
         $amp->realfft;
         my $ps = sqrt($amp(:$N/2-1)**2 + $amp($N/2:)**2);
         # N df dt = 1;
         my $df = 1 / $N / ($xs->at(1) - $xs->at(0));
         my $lower_idx = int(50 / $df); # frequency should be larger 
         # than 50 Hz
         my $upper_idx = int(1000 / $df); # and less than 1000 Hz
         my $freq_idx = $ps($lower_idx:$upper_idx)->maximum_ind->sclr + 
$lower_idx;
#        my $freq_idx = $ps->maximum_ind->sclr;
         #$f = $freq_idx * $df;
         #   = $freq_idx / $N / $dt;
         #$T = $N * $dt / $freq_idx;
         $period_idx = int($N / $freq_idx);
     }

     # Find the first max and min; trigger on the first upward zero crossing
     my $trigger = find_first_crossing_preidx($real, +1, 0, $period_idx 
* 2);
     my ($left_max, $left_max_idx) = find_max($real, $trigger, $trigger 
+ $period_idx / 2);
     my ($left_min, $left_min_idx) = find_min($real, $trigger + 
$period_idx / 2, $trigger + $period_idx);
     my $smooth_near_max = 0;

     # Loop over all min/max pairs
     while (1) {
         # Find the right max and right min. First find the trigger 
         # after the left min (again, trigger is an upward zero crossing)
         last if $left_min_idx+$period_idx >= $real->nelem;
         $trigger = find_first_crossing_preidx($real, +1, $left_min_idx, 
$left_min_idx+$period_idx);

         # Make sure the neighborhood of the next downward zero exists
         last if $trigger + $period_idx >= $real->nelem;

         my ($right_max, $right_max_idx) = find_max($real, $trigger, 
$trigger + $period_idx / 2);
         my ($right_min, $right_min_idx) = find_min($real, $trigger + 
$period_idx / 2, $trigger + $period_idx);

         #############################
         # Downward half of the wave #
         #############################

#        # It's possible to have two values in a row with the same max.
#        # Adjust for that possibility.
       $left_min_idx++ if $real->at($left_min_idx) ==  $real->at($left_min_idx + 1);

         # Calculate the amplitude and mean that we will assume for the 
         # left end
         # of the upward half othis signal
         my $left_mean = ($left_max + $left_min) / 2;
         my $left_amp = ($left_max - $left_min) / 2;

         # Find the middle mean
         my $mid_mean = ($right_max + $left_min) / 2;
         my $mid_amp = ($right_max - $left_min) / 2;

         correct_ys($real, $imag, $left_max_idx, $left_mean, $left_amp,
             $left_min_idx, $mid_mean, $mid_amp);

         # Smooth the imaginary data near the max, if we are ready for that
         smooth_imag($imag, $left_max_idx - $period_idx / 16,
             $left_max_idx + $period_idx / 16) if $smooth_near_max;

         ###########################
         # Upward half of the wave #
         ###########################

#        # As before with two sequential maxima, it's possible to have two
#        # values in a row with the same min. Adjust for that possibility.
       $left_min_idx++ if $real->at($left_min_idx) ==  $real->at($left_min_idx + 1);

         # Calculate the right-end amplitude characteristics
         my $right_mean = ($right_max + $right_min) / 2;
         my $right_amp  = ($right_max - $right_min) / 2;

         correct_ys($real, $imag, $left_min_idx, $mid_mean, $mid_amp,
             $right_max_idx, $right_mean, $right_amp);
         # Flip the sign at the expected zero-crossing point
         $imag($left_min_idx:$right_max_idx) *= -1;

         # Smooth the imaginary data near the min
         smooth_imag($imag, $left_min_idx - $period_idx / 16,
             $left_min_idx + $period_idx / 16);

         ##########################
         # Prepare for next round #
         ##########################

         ($left_max, $left_max_idx, $left_min, $left_min_idx)
             = ($right_max, $right_max_idx, $right_min, $right_min_idx);
         $smooth_near_max = 1;
     }

     # Finally, cut out the data that we didn't manage to correct. Lack of
     # correction is due to (1) didn't find trigger, (2) didn't have a full
     # period past the trigger, and (3) couldn't error-correct the imaginary
     # data. We can identify the first and second cutoffs looking for
     # sequences of zeros:

     my $left_border
         = which(($imag(:-2) == 0) & ($imag(1:) != 0))->at(0) + 1;
     my $right_border
         = which(($imag(:-2) != 0) & ($imag(1:) == 0))->at(-1);
     # To handle the lack of error correction, simply chop off half a period
     # from either end:
     $left_border += $period_idx / 2;
     $right_border -= $period_idx / 2;
     $real = $real($left_border:$right_border)->copy;
     $imag = $imag($left_border:$right_border)->copy;
     return ($real, $imag, $left_border);
}