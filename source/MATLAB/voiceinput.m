%This Function contains the code to take the input from the user then it
%processes the voice array ,compare the input voice commands with database
%input.
function command=voiceinput()

 confirm=input('do you want to record the voice(0/1)')
 %taking input from user
 if(confirm==1)
    record=audiorecorder(22050,8,1);%setting input sampling speed,bits per sample,time of recording.
    disp('recording will start soon')
    recordblocking(record,1);
    disp('recording stopped');
    arr_in=getaudiodata(record);
    % plot(arr_in);
 end
 
 if (confirm==0)
    disp('thank you');
 end
 
 %filtering the input data from start upto threshold value of 0.08
 i=1;
 while (arr_in(i)<0.08),  
    i=i+1;
 end
 l=length(arr_in);
 corr_arr=abs(arr_in(i+1:l));
 plot (corr_arr);

 inarray1=corr_arr;
 inarray=abs(inarray1);%taking absolute value of the input array
 threshold=0.05; %setting threshold value for comparison

 %importing pre-recorded sound files and storing in variables. 
    front1=wavread('C:\Users\Mohit\Downloads\data\front.wav');
    backward1=wavread('C:\Users\Mohit\Downloads\data\backward.wav');
    left1=wavread('C:\Users\Mohit\Downloads\data\left.wav');
    right1=wavread('C:\Users\Mohit\Downloads\data\right.wav');
    stop1=wavread('C:\Users\Mohit\Downloads\data\stop.wav');
    buzzer_on1=wavread('C:\Users\Mohit\Downloads\data\buzzer on.wav');
    off1=wavread('C:\Users\Mohit\Downloads\data\off.wav');
    soft_left1=wavread('C:\Users\Mohit\Downloads\data\soft left.wav');
    soft_right1=wavread('C:\Users\Mohit\Downloads\data\soft right.wav');

%filtering the pre-recorded voice from start and end upto a threshold value.
    arr_in1=front1;
    i=1;
    while (arr_in1(i)<0.08),
        i=i+1;
    end
    l=length(arr_in1);
    corr_arr1=arr_in1(i+1:l);

    i=l-i-1;
    while(corr_arr1(i)<0.1)
        i=i-1;
    end
    front=(0.85)*abs(corr_arr1(1:i));

%filtering the pre-recorded voice from start and end upto a threshold value.
    arr_in2=backward1;
    i=1;
    while (arr_in2(i)<0.08),
        i=i+1;
    end
    l=length(arr_in2);
    corr_arr2=arr_in2(i+1:l);

    i=l-i-1;
    while(corr_arr2(i)<0.1)
        i=i-1;
    end
    backward=(0.85)*abs(corr_arr2(1:i));

%filtering the pre-recorded voice from start and end upto a threshold value.
    arr_in3=left1;
    i=1;
    while (arr_in3(i)<0.08),
        i=i+1;
    end
    l=length(arr_in3);
    corr_arr3=arr_in3(i+1:l);

    i=l-i-1;
    while(corr_arr3(i)<0.1)
        i=i-1;
    end
    left=(0.85)*abs(corr_arr3(1:i));

%filtering the pre-recorded voice from start and end upto a threshold value.
    arr_in4=right1;
    i=1;
    while (arr_in4(i)<0.08),
        i=i+1;
    end
    l=length(arr_in4);
    corr_arr4=arr_in4(i+1:l);

    i=l-i-1;
    while(corr_arr4(i)<0.1)
        i=i-1;
    end
    right=(0.85)*abs(corr_arr4(1:i));
    
%filtering the pre-recorded voice from start and end upto a threshold value
    arr_in5=stop1;
    i=1;
    while (arr_in5(i)<0.08),
        i=i+1;
    end
    l=length(arr_in5);
    corr_arr5=arr_in5(i+1:l);

    i=l-i-1;
    while(corr_arr5(i)<0.1)
        i=i-1;
    end
    stop=(0.85)*abs(corr_arr5(1:i));

%filtering the pre-recorded voice from start and end upto a threshold value.
    arr_in6=buzzer_on1;
    i=1;
    while (arr_in5(i)<0.08),
        i=i+1;
    end
    l=length(arr_in6);
    corr_arr6=arr_in6(i+1:l);

    i=l-i-1;
    while(corr_arr6(i)<0.1)
        i=i-1;
    end
    buzzer_on=(0.85)*abs(corr_arr6(1:i));

%filtering the pre-recorded voice from start and end upto a threshold value.
    arr_in7=stop1;
    i=1;
    while (arr_in7(i)<0.08),
        i=i+1;
    end
    l=length(arr_in7);
    corr_arr7=arr_in7(i+1:l);

    i=l-i-1;
    while(corr_arr7(i)<0.1)
        i=i-1;
    end
    off=(0.85)*abs(corr_arr7(1:i));

%filtering the pre-recorded voice from start and end upto a threshold value.
    arr_in8=soft_left1;
    i=1;
    while (arr_in8(i)<0.08),
        i=i+1;
    end
    l=length(arr_in8);
    corr_arr8=arr_in8(i+1:l);

    i=l-i-1;
    while(corr_arr8(i)<0.1)
        i=i-1;
    end
    soft_left=(0.85)*abs(corr_arr8(1:i));


%filtering the pre-recorded voice from start and end upto a threshold value.
    arr_in9=soft_right1;
    i=1;
    while (arr_in9(i)<0.08),
        i=i+1;
    end
    l=length(arr_in9);
    corr_arr9=arr_in9(i+1:l);

    i=l-i-1;
    while(corr_arr9(i)<0.1)
        i=i-1;
    end
    soft_right=(0.85)*abs(corr_arr9(1:i));




%calculating length of array
    l1=length(front);
    l2=length(backward);
    l3=length(left);
    l4=length(right);
    l5=length(stop);
    l6=length(buzzer_on);
    l7=length(off);
    l8=length(soft_left);
    l9=length(soft_right);

%making comparison arrays of the length equal to the one with which they
%are to be compared
    comp1=inarray(1:l1);
    comp2=inarray(1:l2);
    comp3=inarray(1:l3);
    comp4=inarray(1:l4);
    comp5=inarray(1:l5);
    comp6=inarray(1:l6);
    comp7=inarray(1:l7);
    comp8=inarray(1:l8);
    comp9=inarray(1:l9);

%counting the number of values which are below threshold in the subtraction
%array.

    i=0;
    counter1=0;
    check1=abs(comp1-front);%make sure input array is of absolute value
    for i=1:l1;
        if(check1(i)<threshold)
            counter1=counter1+1;
        end
    end

    i=0;
    counter2=0;
    check2=abs(comp2-backward);%make sure input array is of absolute value
    for i=1:l2;
        if(check2(i)<threshold)
            counter2=counter2+1;
        end
    end

    i=0;
    counter3=0;
    check3=abs(comp3-left);%make sure input array is of absolute value
    for i=1:l3;
        if(check3(i)<threshold)
            counter3=counter3+1;
        end
    end

    i=0;
    counter4=0;
    check4=abs(comp4-right);%make sure input array is of absolute value
    for i=1:l4;
        if(check4(i)<threshold)
            counter4=counter4+1;
        end
    end

    i=0;
    counter5=0;
    check5=abs(comp5-stop);%make sure input array is of absolute value
    for i=1:l5;
        if(check5(i)<threshold)
            counter5=counter5+1;
        end
    end

    i=0;
    counter6=0;
    check6=abs(comp6-buzzer_on);%make sure input array is of absolute value
    for i=1:l6;
        if(check6(i)<threshold)
            counter6=counter6+1;
        end
    end

    i=0;
    counter7=0;
    check7=abs(comp7-off);%make sure input array is of absolute value
    for i=1:l7;
        if(check7(i)<threshold)
            counter7=counter7+1;
        end
    end

    i=0;
    counter8=0;
    check8=abs(comp8-soft_left);%make sure input array is of absolute value
    for i=1:l8;
        if(check8(i)<threshold)
            counter8=counter8+1;
        end
    end

    i=0;
    counter9=0;
    check9=abs(comp9-soft_right);%make sure input array is of absolute value
    for i=1:l8;
        if(check9(i)<threshold)
            counter9=counter9+1;
        end
    end

% To display the difference counter
    disp(counter1);
    disp(counter2);
    disp(counter3);
    disp(counter4);
    disp(counter5);
    disp(counter6);
    disp(counter7);
    disp(counter8);
    disp(counter9);

    
%storing all the counter values in an array.
    commarray(1,1)=counter1;
    commarray(1,2)=counter2;
    commarray(1,3)=counter3;
    commarray(1,4)=counter4;
    commarray(1,5)=counter5;
    commarray(1,6)=counter6;
    commarray(1,7)=counter7;
    commarray(1,8)=counter8;
    commarray(1,9)=counter9;

%taking the maximum element entry of the array.
    compoutput=max(commarray);
    display(compoutput);
%initializing the com port
    s=serial('COM7');
    fopen(s);
%checking the maximum value with the counter values and assigning command
%accordingly.
    if(compoutput==counter1)
        command=8;
        disp('front');
        fwrite(s,56,'uint8');%sending byte value to com port
        fwrite(s,56,'uint8');

    elseif(compoutput==counter2)
        command=2;
        disp('backward');
        fwrite(s,50,'uint8');%sending byte value to com port

    elseif(compoutput==counter3)
        command=4;
        disp('left');
        fwrite(s,52,'uint8');%sending byte value to com port

    elseif(compoutput==counter4)
        command=6;
        disp('right');
        fwrite(s,54,'uint8');%sending byte value to com port

    elseif(compoutput==counter5)
        command=5;
        disp('stop');
        fwrite(s,53,'uint8');%sending byte value to com port

    elseif(compoutput==counter6)
        command=7;
        disp('buzzer_on');
        fwrite(s,55,'uint8');%sending byte value to com port

    elseif(compoutput==counter7)
        command=9;
        disp('buzzer off');
        fwrite(s,57,'uint8');%sending byte value to com port

    elseif(compoutput==counter8)
        command=1;
        disp('soft left');
        fwrite(s,49,'uint8');%sending byte value to com port

    elseif(compoutput==counter9)
        command=3;
        disp('soft right');
        fwrite(s,51,'uint8');%sending byte value to com port


    else
        command=0;
        disp('no command found');
    end
end





