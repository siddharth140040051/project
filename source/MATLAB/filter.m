%the basic function of this script file is to filter the voice commands
%Here we have created a LOW PASS FILTER by windowing method


%importing pre-recorded sound files and storing in variables.
    front1=wavread('C:\Users\Mohit\Downloads\data\front.wav');
    backward1=wavread('C:\Users\Mohit\Downloads\data\backward.wav');
    left1=wavread('C:\Users\Mohit\Downloads\data\left.wav');
    right1=wavread('C:\Users\Mohit\Downloads\data\right.wav');
%filtering the front input
    i=1;
    a=front1;

    hold on;
    l=length(a);
    while(i<l-1000)
        j=1;
        sum=0;
        while(j<1001)
            sum=sum+abs(a(i+j-1));
            j=j+1;
        end;
        c(i)=sum*0.001;
        i=i+1;
    end;
    plot (c);
    hold on
    i=1;
    a=left1;
    
%filtering the left input
    hold on;
    l=length(a);
    while(i<l-1000)
        j=1;
        sum=0;
        while(j<1001)
            sum=sum+abs(a(i+j-1));
            j=j+1;
        end;
        c(i)=sum*0.001;
        i=i+1;
    end;
    plot (c,'y');
    
 %filtering the right input
    i=1;
    a=right1;

    hold on;
    l=length(a);
    while(i<l-1000)
        j=1;
        sum=0;
        while(j<1001)
            sum=sum+abs(a(i+j-1));
            j=j+1;
        end;
        c(i)=sum*0.001;
        i=i+1;
    end;
    plot (c,'r');
%filtering the backward input
    i=1;
    a=left1backward;

    hold on;
    l=length(a);
    while(i<l-1000)
        j=1;
        sum=0;
        while(j<1001)
            sum=sum+abs(a(i+j-1));
            j=j+1;
        end;
        c(i)=sum*0.001;
        i=i+1;
    end;
    plot (c,'g');