%% Q1 - a

clear; clc; close all;

b = [1, -2.1, 2.7];
a = [1, 0.3126, 0.81];

zplane(b,a);

figure;

w = -pi:0.01*pi:pi;

Hw = impz(b,a,length(w));
Hw = fft(Hw);
Hw = fftshift(Hw);

plot(w,abs(Hw));

%% Q1 - c

clear; clc; close all;

b = [3, -126/54, 3/2.7];
a = [1, 0.3126, 0.81];

w = -pi:0.01*pi:pi;

% Hmp(w)

Hmp = impz(b,a,length(w));
Hmp = fft(Hmp);
Hmp = fftshift(Hmp);

plot(w,abs(Hmp));

figure;

% Hap(w)

b = [3/2.7, -126/54, 3];
a = [3, -126/54, 3/2.7];

Hmp = impz(b,a,length(w));
Hmp = fft(Hmp);
Hmp = fftshift(Hmp);

plot(w,abs(Hmp));

%% Q1 - d

clear; clc; close all;

% Hmp(z)

b = [3, -126/54, 3/2.7];
a = [1, 0.3126, 0.81];

zplane(b,a);

figure;

% Hap(z)

b = [1/2.7, -42/54, 1];
a = [3, -126/54, 3/2.7];

zplane(b,a);

%% Q2 - a

clear; clc; close all;

b = [1, 0, 1.75, 0, -0.5];
a = [1, 0, 0, 0, 0.4096];

zplane(b,a);

figure;

w = -pi:0.01*pi:pi;

Hw = impz(b,a,length(w));
Hw = fft(Hw);
Hw = fftshift(Hw);

plot(w,abs(Hw));

%% Q2 - c

clear; clc; close all;

w = -pi:0.01*pi:pi;

% Hmp(w)

Hmp = (-2-1/2.*exp(-j*2.*w)+1/4.*exp(-j*4.*w))./(1+0.4096.*exp(-j*4.*w));

plot(w,abs(Hmp));

figure;

% Hap(w)

Hap = (1/2+1.*exp(-j*2.*w))./(1+1/2.*exp(-j*2.*w));

plot(w,abs(Hap));

%% Q2 - d

clear; clc; close all;

b = [-2, 0, -1/2, 0, 1/4];
a = [1, 0, 0, 0, 0.4096];

zplane(b,a);

figure;

b = [1/2, 0, 1];
a = [1, 0, 1/2];

zplane(b,a);

%% Q3 - a

clear; clc; close all;

n = 0:300;

b = [1.801,0,0, 0, 0, 0, 0, 0, 0, 0, 0, -1.801];
a = [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1.602];
h = impz(b,a, 301);
stem(n,h);

%% Q3 - b

clear; clc; close all;

w = -pi:0.01*pi:pi;

Hw = (1.801-1.801.*exp(-j*11*w))./(2-(2*(0.98^11)).*exp(-j*11.*w));
plot(w,abs(Hw));

%% Q3 - c

clear; clc; close all;

Fs = 2200;
w = linspace(-pi, pi, 17600);

Hw = (1.801-1.801.*exp(-j*11*w))./(2-1.602.*exp(-j*11.*w));

plot(w.*(Fs/(2*pi)),abs(Hw))

%% Q4

% a

clear; clc; close all;

b = zeros(1,41);
a = [1];
n = 0:64;

p=20;

for l = 1:41
    
    bl = (0.54-0.46*cos(pi*l/p))*(sin(0.75*pi*(l-p-1)-sin(0.25*pi*(l-p-1))))/(pi*(l-p-1));

    if l == 21;
        bl = 0.5;
    end

    b(l) = bl;

end

y = impz(b,a,65);
plot(n,y);

figure;

% b

w = linspace(-pi,pi,65);

Hw = fft(y);
Hw = fftshift(y);
plot(w,abs(Hw));

figure;

% c

Fs = 200;
plot(w.*(Fs/(2*pi)),abs(Hw));