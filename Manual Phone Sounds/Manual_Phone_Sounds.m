clear; clc; close all

%% Run This Section (Change the string to see what you get)

clear; clc; close all

%soundsc(single_dtmf('1', 1600),8000); % Un-Comment to test each char
 
soundsc(atdt('048294780#*'),8000);

%% Functions

function h_figure = change_figure() 

x = -2*pi:0.01*pi:2*pi;

plot(x,cos(x),'g','LineWidth',4);
hold on
plot(x,sin(x),'r','LineWidth',3);

get(gca);
get(gcf);

ax = gca;
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.XColor = [0 1 0];
ax.YColor = [0 0 1];
ax.FontSize = 12;
ax.FontName = 'Times';
ax.XLim = [0 2*pi];
ax.XScale = 'log';

fx = gcf;
fx.NumberTitle = 'off';
fx.Name = 'Sine & Cosine';
fx.Color = [1 0 1];
fx.Color = [1 1 0];

h_figure = fx;

end

function y = my_conv(x1,x2)
    mat= x1.*x2';
    flpmat = fliplr(mat);
    y=[sum(diag(flpmat,-3)),sum(diag(flpmat,-2)),sum(diag(flpmat,-1)),sum(diag(flpmat,0)),sum(diag(flpmat,1)),sum(diag(flpmat,2)),sum(diag(flpmat,3))];
    y=fliplr(y);
end

function tone = single_dtmf(button ,N)

Fs = 8000; Ts = 1 / Fs;
t = 0 : Ts : 1;

s = @(f1,f2) 0.5*(cos(2 * pi * f1 * t)+cos(2 * pi * f2 * t));

if (button == '1')
    signal = s(697,1209);
    tone = signal(1:N);
end

if (button == '2')
    signal = s(697,1336);
    tone = signal(1:N);
end

if (button == '3')
    signal = s(697,1477);
    tone = signal(1:N);
end

if (button == '4')
    signal = s(770,1209);
    tone = signal(1:N);
end

if (button == '5')
    signal = s(770,1336);
    tone = signal(1:N);
end

if (button == '6')
    signal = s(770,1477);
    tone = signal(1:N);
end

if (button == '7')
    signal = s(852,1209);
    tone = signal(1:N);
end

if (button == '8')
    signal = s(852,1336);
    tone = signal(1:N);
end

if (button == '9')
    signal = s(852,1447);
    tone = signal(1:N);
    
end

if (button == '*')
    signal = s(941,1209);
    tone = signal(1:N);
    
end

if (button == '0')
    signal = s(941,1336);
    tone = signal(1:N);
    
end

if (button == '#')
    signal = s(941,1447);
    tone = signal(1:N);
    
end

end

function dial_vec = atdt(str)

[r,c] = size(str);
for kk = 1:c
    values = single_dtmf(str(kk), 1600);
    for ww = 1:1600
        dial_vec(ww+(kk-1)*2000) = values(ww);
    end
    for oo = 1:400
        if(oo+1600+2000*(kk-1) <= 10000)
            dial_vec(oo+1600+2000*(kk-1)) = 0;
        end
        
    end
end

grid on
h_s = stem(dial_vec);

xd = h_s.XData;
yd = h_s.YData;

zeroIndices = (yd == 0);

xd = xd(zeroIndices);

hold on

[r,c] = size(xd);

y = zeros(1,c);

stem(xd,y,'r');

title('Phone Sounds')
xlabel('N')
ylabel('Y Value')
axis([0 9600 -1 2])

end