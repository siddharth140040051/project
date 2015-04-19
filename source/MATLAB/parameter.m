function [command]=parameter(compoutput)
s=serial('COM7');
fopen(s);

if(compoutput==8)
    command=8;
    disp('front');
    fwrite(s,56,'uint8');
    fwrite(s,56,'uint8');
    
elseif(compoutput==2)
    command=2;
    disp('backward');
    fwrite(s,50,'uint8');
    
elseif(compoutput==4)
    command=4;
    disp('left');
    fwrite(s,52,'uint8');
    disp('left');

elseif(compoutput==6)
    fwrite(s,54,'uint8');
    command=6;
    disp('right');
   
elseif(compoutput==5)
    command=5;
    disp('stop');
    
elseif(compoutput==7)
    command=7;
    disp('buzzer_on');
    fwrite(s,55,'uint8');
elseif(compoutput==9)
    command=9;
    disp('buzzer off');
    fwrite(s,57,'uint8');

elseif(compoutput==1)
    command=1;
    fwrite(s,49,'uint8');
    disp('soft left');
    
elseif(compoutput==3)
    command=3;
    disp('soft right');
    fwrite(s,51,'uint8');


else    
    command=11;
    disp('no command found');
end

fclose(s);