function printImage( fileName )
%Printimage creates a high resolution image from the current figure, and
%prints it to the Desktop. If used on different machines, be sure to
%specify a path to avoid errors. 


rez=1200; %resolution (dpi) of final graphic
f=gcf; %f is the handle of the figure you want to export
figpos=getpixelposition(f); %dont need to change anything here
resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
path='C:\Users\fritz\Desktop'; %the folder where you want to put the file
name=fileName; %what you want the file to be called
print(f,fullfile(path,name),'-dpng',['-r',num2str(rez)],'-opengl') %save file




end

