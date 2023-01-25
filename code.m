%------------------- read audio signals---------------------------%
[y1,fs1]=audioread('signal1.wav');
[y2,fs2]=audioread('signal2.wav');
[y3,fs3]=audioread('signal3.wav');
%sound(y1,fs1);

%---------------------------variables----------------------------%
 y1 = y1(:,1);
 y2 = y2(:,1);
 y3 = y3(:,1);
%----------------------------------------------------------------%
 ts1 = 1/fs1;
 ts2 = 1/fs2;
 ts3 = 1/fs3;
 t1 = 0:ts1:(length(y1)-1)/fs1;
 t2 = 0:ts2:(length(y2)-1)/fs2;
 t3 = 0:ts3:(length(y3)-1)/fs3;
%----------------------------------------------------------------%
 f1 = -fs1/2:fs1/2;
 f2 = -fs2/2:fs2/2;
 f3 = -fs3/2:fs3/2;
%---------------------------resampling------------------------------%
Fs=250000;
[p,q] = rat(Fs/fs1);
resamplSignal1 = resample(y1,p,q);

[p,q] = rat(Fs/fs2);
resamplSignal2 = resample(y2,p,q);

[p,q] = rat(Fs/fs3);
resamplSignal3 = resample(y3,p,q);
%----------------------------------------------------------------%
ts=1/Fs;
f = -Fs/2:Fs/2;
timeAfterReSampling1=0:ts:(length(resamplSignal1)-1)*ts;
timeAfterReSampling2=0:ts:(length(resamplSignal2)-1)*ts;
timeAfterReSampling3=0:ts:(length(resamplSignal3)-1)*ts;


%----------------------------------------------------------------%
y1_amplitude=abs(fftshift(fft(resamplSignal1,Fs+1))); 
y2_amplitude=abs(fftshift(fft(resamplSignal2,Fs+1))); 
y3_amplitude=abs(fftshift(fft(resamplSignal3,Fs+1))); 
%------------plotting originsl signal1 in in time and frequency domain-------------%
figure;

subplot(2,1,1);
plot(timeAfterReSampling1,resamplSignal1);
title('Original signal 1 in time domain');
xlabel('time');
ylabel('amplitude');

subplot(2,1,2);
plot(f,y1_amplitude);
title('Original signal 1 amplitude in frequency domain');
xlabel('frequency');
ylabel('amplitude');

%------------plotting originsl signal2 in in time and frequency domain-------------%

figure;
subplot(2,1,1);
plot(timeAfterReSampling2,resamplSignal2);
title('Original signal 2 in time domain');
xlabel('time');
ylabel('amplitude');

subplot(2,1,2);
plot(f,y2_amplitude);
title('Original signal 2 amplitude in frequency domain');
xlabel('frequency');
ylabel('amplitude');

%------------plotting originsl signal3 in in time and frequency domain-------------%

figure;
subplot(2,1,1);
plot(timeAfterReSampling3,resamplSignal3);
title('Original signal 3 in time domain');
xlabel('time');
ylabel('amplitude');

subplot(2,1,2);
plot(f,y3_amplitude);
title('Original signal 3 amplitude in frequency domain');
xlabel('frequency');
ylabel('amplitude');
%----------------------------------------------------------------%
fc1=50000;
fc2=100000;


%------------plotting modulated signal1 in in time and frequency domain-------------%
% signal 1
c1=cos(2*pi*fc1*timeAfterReSampling1).';
modulated_signal1=(resamplSignal1).*c1;
modulated_amplitude1 = abs(fftshift(fft(modulated_signal1,Fs+1)));
figure;
subplot(2,1,1);
plot(timeAfterReSampling1,modulated_signal1);
title('Modulated signal 1 in time domain');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,modulated_amplitude1);
title('Modulated signal 1 amplitude in frequency Domain');
xlabel('frequency');
ylabel('amplitude');

%------------plotting modulated signal2 in in time and frequency domain-------------%
% signal 2
figure;
c2=cos(2*pi*fc2*timeAfterReSampling2).';
modulated_signal2=(resamplSignal2).*c2;
modulated_amplitude2 = abs(fftshift(fft(modulated_signal2,Fs+1))); 

subplot(2,1,1);
plot(timeAfterReSampling2,modulated_signal2);
title('Modulated signal 2 in time domain');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,modulated_amplitude2);
title('Modulated signal 2 amplitude in frequency Domain');
xlabel('frequency');
ylabel('amplitude');

%------------plotting modulated signal3 in in time and frequency domain-------------%
% signal 3
figure;
c3=sin(2*pi*fc2*timeAfterReSampling3).';
modulated_signal3=(resamplSignal3).*c3;
modulated_amplitude3 = abs(fftshift(fft(modulated_signal3,Fs+1))); 

subplot(2,1,1);
plot(timeAfterReSampling3,modulated_signal3);
title('Modulated signal 3 in time domain');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,modulated_amplitude3);
title('Modulated signal 3 amplitude in frequency Domain');
xlabel('frequency');
ylabel('amplitude');
%-----------------------------Sum-----------------------------%
len = max(length(modulated_signal1), max(length(modulated_signal2),length(modulated_signal3)));
t = 0:ts:(len-1)*ts;

SignalwithLengthLen1=[modulated_signal1;zeros(len-length(modulated_signal1), 1)];
SignalwithLengthLen2=[modulated_signal2;zeros(len-length(modulated_signal2), 1)];
SignalwithLengthLen3=[modulated_signal3;zeros(len-length(modulated_signal3), 1)];

sumModulated=SignalwithLengthLen1+SignalwithLengthLen2+SignalwithLengthLen3;

sumModulated_frequencyDomain = abs(fftshift(fft(sumModulated,Fs+1))); 
%---------------------plotting modulated signal-------------------%
figure;

subplot(2,1,1);
plot(t,sumModulated);
title('Sum of Modulated signals in time domain');
xlabel('time');
ylabel('amplitude');

subplot(2,1,2);
plot(f,sumModulated_frequencyDomain);
title('Sum of Modulated signals in frequency Domain');
xlabel('frequency');
ylabel('amplitude');

%---------------------restore first signal-------------------%
sync_carr1 = cos(2*pi*fc1*t).';
demodulated11=(sumModulated).*sync_carr1;
demodulated11=lowpass(demodulated11,fc1,Fs*3);
demodulated_amplitude1= abs(fftshift(fft(demodulated11,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated11);
title('Demodulated signal 1 in time domain');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude1);
title('Demodulated signal 1 amplitude in frequency Domain');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal1.wav',demodulated11,Fs);
%---------------------restore second signal-------------------%
sync_carr2 = cos(2*pi*fc2*t).';
demodulated12=(sumModulated).*sync_carr2;
demodulated12=lowpass(demodulated12,fc1,Fs*3);
demodulated_amplitude2= abs(fftshift(fft(demodulated12,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated12);
title('Demodulated signal 2 in time domain');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude2);
title('Demodulated signal 2 amplitude in frequency Domain');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal2.wav',demodulated12,Fs);
%---------------------restore third signal-------------------%
sync_carr3 = sin(2*pi*fc2*t).';
demodulated13=(sumModulated).*sync_carr3;
demodulated13=lowpass(demodulated13,fc1,Fs*3);
demodulated_amplitude3= abs(fftshift(fft(demodulated13,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated13);
title('Demodulated signal 3 in time domain');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude3);
title('Demodulated signal 3 amplitude in frequency Domain');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal3.wav',demodulated13,Fs);
%---------------------pjase shift 10-------------------%
%---------------------restore first signal-------------------%
sync_carr1 = cos(2*pi*fc1*t+10*pi/180).';
demodulated11=(sumModulated).*sync_carr1;
demodulated11=lowpass(demodulated11,fc1,Fs*3);
demodulated_amplitude1= abs(fftshift(fft(demodulated11,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated11);
title('Demodulated signal 1 in time domain with phase 10');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude1);
title('Demodulated signal 1 amplitude in frequency Domain with phase 10');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal1_phase_10.wav',demodulated11,Fs);
%---------------------restore second signal-------------------%
sync_carr2 = cos(2*pi*fc2*t+10*pi/180).';
demodulated12=(sumModulated).*sync_carr2;
demodulated12=lowpass(demodulated12,fc1,Fs*3);
demodulated_amplitude2= abs(fftshift(fft(demodulated12,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated12);
title('Demodulated signal 2 in time domain with phase 10');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude2);
title('Demodulated signal 2 amplitude in frequency Domain with phase 10');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal2_phase_10.wav',demodulated12,Fs);
%---------------------restore third signal-------------------%
sync_carr3 = sin(2*pi*fc2*t+10*pi/180).';
demodulated13=(sumModulated).*sync_carr3;
demodulated13=lowpass(demodulated13,fc1,Fs*3);
demodulated_amplitude3= abs(fftshift(fft(demodulated13,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated13);
title('Demodulated signal 3 in time domain with phase 10');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude3);
title('Demodulated signal 3 amplitude in frequency Domain with phase 10');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal3_phase_10.wav',demodulated13,Fs);

%---------------------pjase shift 30-------------------%
%---------------------restore first signal-------------------%
sync_carr1 = cos(2*pi*fc1*t+30*pi/180).';
demodulated11=(sumModulated).*sync_carr1;
demodulated11=lowpass(demodulated11,fc1,Fs*3);
demodulated_amplitude1= abs(fftshift(fft(demodulated11,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated11);
title('Demodulated signal 1 in time domain with phase 30');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude1);
title('Demodulated signal 1 amplitude in frequency Domain with phase 30');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal1_phase_30.wav',demodulated11,Fs);
%---------------------restore second signal-------------------%
sync_carr2 = cos(2*pi*fc2*t+30*pi/180).';
demodulated12=(sumModulated).*sync_carr2;
demodulated12=lowpass(demodulated12,fc1,Fs*3);
demodulated_amplitude2= abs(fftshift(fft(demodulated12,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated12);
title('Demodulated signal 2 in time domain with phase 30');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude2);
title('Demodulated signal 2 amplitude in frequency Domain with phase 30');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal2_phase_30.wav',demodulated12,Fs);
%---------------------restore third signal-------------------%
sync_carr3 = sin(2*pi*fc2*t+30*pi/180).';
demodulated13=(sumModulated).*sync_carr3;
demodulated13=lowpass(demodulated13,fc1,Fs*3);
demodulated_amplitude3= abs(fftshift(fft(demodulated13,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated13);
title('Demodulated signal 3 in time domain with phase 30');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude3);
title('Demodulated signal 3 amplitude in frequency Domain with phase 30');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal3_phase_30.wav',demodulated13,Fs);

%---------------------pjase shift 90-------------------%
%---------------------restore first signal-------------------%
sync_carr1 = cos(2*pi*fc1*t+90*pi/180).';
demodulated11=(sumModulated).*sync_carr1;
demodulated11=lowpass(demodulated11,fc1,Fs*3);
demodulated_amplitude1= abs(fftshift(fft(demodulated11,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated11);
title('Demodulated signal 1 in time domain with phase 90');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude1);
title('Demodulated signal 1 amplitude in frequency Domain with phase 90');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal1_phase_90.wav',demodulated11,Fs);
%---------------------restore second signal-------------------%
sync_carr2 = cos(2*pi*fc2*t+90*pi/180).';
demodulated12=(sumModulated).*sync_carr2;
demodulated12=lowpass(demodulated12,fc1,Fs*3);
demodulated_amplitude2= abs(fftshift(fft(demodulated12,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated12);
title('Demodulated signal 2 in time domain with phase 90');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude2);
title('Demodulated signal 2 amplitude in frequency Domain with phase 90');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal2_phase_90.wav',demodulated12,Fs);
%---------------------restore third signal-------------------%
sync_carr3 = sin(2*pi*fc2*t+90*pi/180).';
demodulated13=(sumModulated).*sync_carr3;
demodulated13=lowpass(demodulated13,fc1,Fs*3);
demodulated_amplitude3= abs(fftshift(fft(demodulated13,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated13);
title('Demodulated signal 3 in time domain with phase 90');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude3);
title('Demodulated signal 3 amplitude in frequency Domain with phase 90');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal3_phase_90.wav',demodulated13,Fs);

%---------------------Frequrncy shift 2-------------------%
sync_carr1 = cos(2*pi*(fc1+10)*t).';
demodulated11=(sumModulated).*sync_carr1;
demodulated11=lowpass(demodulated11,fc1,Fs*3);
demodulated_amplitude1= abs(fftshift(fft(demodulated11,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated11);
title('Demodulated signal 1 in time domain with frequency shift 2');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude1);
title('Demodulated signal 1 amplitude in frequency Domain with frequency shift 2');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal1_freq_2.wav',demodulated11,Fs);

%---------------------Frequrncy shift 10-------------------%
sync_carr1 = cos(2*pi*(fc1+2)*t).';
demodulated11=(sumModulated).*sync_carr1;
demodulated11=lowpass(demodulated11,fc1,Fs*3);
demodulated_amplitude1= abs(fftshift(fft(demodulated11,Fs+1)));

figure;
subplot(2,1,1);
plot(t,demodulated11);
title('Demodulated signal 1 in time domain with frequency shift 10');
xlabel('time');
ylabel('amplitude');
subplot(2,1,2);
plot(f,demodulated_amplitude1);
title('Demodulated signal 1 amplitude in frequency Domain with frequency shift 10');
xlabel('frequency');
ylabel('amplitude');

audiowrite('demodulatedSignal1_freq_10.wav',demodulated11,Fs);
