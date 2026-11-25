

Fs=1000;
acc = ts2timetable(out.body_acc);
x = x()
psdest = psd(spectrum.periodogram,x,'Fs',Fs,'NFFT',length(x));
plot(psdest.Frequencies, psdest.Data); grid on;
ylabel('g^2/Hz');
xlabel('Hz');

timetable2table(acc);
x = ans(:,1); 
y = ans(:,2); 
t = length(Time);
Fs = 1; 
h = spectrum.welch; 
y = table2array(y);
plot(psd(h,y,'Fs',Fs,'NFFT',t));

pid_acc = ts2timetable(out.pid_acc);

fData = fft2(y); % pad with zeros as you see fit to avoid aliasing
imagesc(log10(abs(fftshift(fData)).^2))

road = ts2timetable(out.road_displacement);
road2 = timetable2table(road);
road3 = table2array(road);
body_displacement = ts2timetable(out.body_displacement);
body_displacement2 = table2array(body_displacement);
passive_displacement = ts2timetable(out.passive_displacement);
passive_displacement2 = table2array(passive_displacement);
[p1,w1] = pwelch(road3)
[p2,w2] = pwelch(body_displacement2)
hold on
[p3,w3] = pwelch(passive_displacement2)
loglog(w1,p1)
xlim([0.005 10])
hold on
loglog(w2,p2)
loglog(w3,p3)

body_acc = ts2timetable(out.body_acc);
body_acc2 = table2array(body_acc);
passive_acc = ts2timetable(out.passive_acc);
passive_acc2 = table2array(passive_acc);
pid_acc = ts2timetable(out.pid_acc);
pid_acc2 = table2array(pid_acc);
[p4,w4] = pwelch(body_acc2);
[p5,w5] = pwelch(passive_acc2);
[p6,w6] = pwelch(pid_acc2);
loglog(w4,p4);
hold on
loglog(w5,p5);
loglog(w6,p6);

pwelch(body_acc2);
hold on
pwelch(passive_acc2);
pwelch(pid_acc2);

[p,w] = pwelch(road3,hamming(2000),1000,2000,'onesided','power');
loglog(w,p);
grid on
fs = 20;
[pxx1,f1] = pwelch(body_acc2,50,30,50,fs,'centered','power');
loglog(f1,pxx1)
hold on
[pxx2,f2] = pwelch(passive_acc2,50,30,50,fs,'centered','power');
loglog(f2,pxx2)
[pxx3,f3] = pwelch(pid_acc2,50,30,50,fs,'centered','power');
loglog(f3,pxx3)
hold off

%% Result (skyhook included)
% Body displacement (passive, DDPG, sky)


controlforce = ts2timetable(out.control_force);

%
test = ts2timetable(out.simout);
test2 = table2array(test);

test3 = ts2timetable(out.simout1);
test4 = table2array(test3);

[p1,w1] = pwelch(test2)
[p2,w2] = pwelch(test4)

loglog(w1,p1)
hold on
loglog(w2,p2)


% PSD

passive_displacement = ts2timetable(out.passive_displacement);
passive_displacement2 = table2array(passive_displacement);

rl_displacement = ts2timetable(out.body_displacement);
rl_displacement2 = table2array(rl_displacement);

pid_displacement = ts2timetable(out.pid_displacement);
pid_displacement2 = table2array(pid_displacement);

passive_displacement3 = ts2timetable(out.passive_displacement);
passive_displacement4 = table2array(passive_displacement3);

rl_displacement3 = ts2timetable(out.body_displacement);
rl_displacement4 = table2array(rl_displacement3);

pid_displacement3 = ts2timetable(out.pid_displacement);
pid_displacement4 = table2array(pid_displacement3);

[p1,w1] = pwelch(passive_displacement2)
[p2,w2] = pwelch(passive_displacement4)
[p3,w3] = pwelch(rl_displacement2)
[p4,w4] = pwelch(rl_displacement4)
[p5,w5] = pwelch(pid_displacement2)
[p6,w6] = pwelch(pid_displacement4)

loglog(w1,p1);
hold on
loglog(w2,p2);
loglog(w3,p3);

[p1,w1] = pwelch(passive_acc2);
hold on
[p2,w2] = pwelch(rl_acc2);
[p3,w3] = pwelch(pid_acc2);

% a = cumtrapz(w1,p1);
% passive_last = a(end,:);
% b = cumtrapz(w2,p2);
% rl_last = b(end,:);
% c = cumtrapz(w3,p3);
% pid_last = c(end,:);

passive_area = trapz(w1,p1);
passive_area2 = trapz(w2,p2);
rl_area = trapz(w2,p2);
rl_area2 = trapz(w4,p4);
pid_area = trapz(w3,p3);
pid_area2 = trapz(w6,p6);

Fs=128;
N11 = length(passive_displacement2);
%N1= length(signal1);
ydft = fft(passive_displacement2);
ydft = ydft(1:N11/2+1);

psdy = (1/(Fs*N11)) * abs(ydft).^2;
psdy(2:end-1) = 2*psdy(2:end-1);

freq = 0:Fs/length(passive_displacement2):Fs/2;

%%
figure (11)

% subplot(2,1,1)
loglog (freq,psdy, 'b')




%%RMS

% input : rand
passive_displacement = ts2timetable(out.passive_displacement);
passive_displacement2 = table2array(passive_displacement);
passive_acc = ts2timetable(out.passive_acc);
passive_acc2 = table2array(passive_acc);

rms_value_passive_sine = rms(passive_displacement2);
rms_value_passive_acc_sine = rms(passive_acc2);

rl_displacement = ts2timetable(out.body_displacement);
rl_displacement2 = table2array(rl_displacement);
rl_acc = ts2timetable(out.body_acc);
rl_acc2 = table2array(rl_acc);

rms_value_rl_sine = rms(rl_displacement2);
rms_value_rl_acc_sine = rms(rl_acc2);

pid_displacement = ts2timetable(out.pid_displacement);
pid_displacement2 = table2array(pid_displacement);
pid_acc = ts2timetable(out.pid_acc);
pid_acc2 = table2array(pid_acc);

rms_value_pid_sine = rms(pid_displacement2);
rms_value_pid_acc_sine = rms(pid_acc2);


rms_value_passive=rms(passive_acc2);
rms_value_pid=rms(pid_acc2);
rms_value_rl=rms(rl_acc2);

rms_value_passive=rms(passive_displacement2);
rms_value_pid=rms(pid_displacement2);
rms_value_rl=rms(rl_displacement2);


rms(rms_value_rl)


s=passive_acc2;
Fs=10;
L=numel(s);
t = linspace(0, L, L)/Fs;
Ts = 1/Fs;
Fn = Fs/2;
t = linspace(0, L, L)*Ts;
ms = mean(s);
FTs = fft(s)/L;
Fv = linspace(0, 1, fix(L/2)+1)*Fn;
Iv = 1:numel(Fv);

plot(Fv, mag2db(abs(FTs(Iv))*2))
grid
xlabel('Frequency (Hz)')
ylabel('Power (Units^2)')
figure
semilogy(Fv, abs(FTs(Iv))*2)
grid
xlabel('Frequency (Hz)')
ylabel('Amplitude (Units)')
