%% Signal Smoothing
clear;clc;close all;

t = linspace(-1,1,1000);

f = @(x) sin(6*pi*x)+sin(12*pi*x);

x_values = arrayfun(f,t);

for n = 1:length(x_values)
    x_values(n) = x_values(n)+ 0.01*randn();
end

u = mySmoothing(x_values,10);

plot(x_values,"b")
hold on
plot(u,"r")
xlabel('t')
ylabel('Value')
legend('Original Signal', 'Smooth Signal')

%% Functions

%% Ex 1

function Sn = myGeoSum(a,r,N)
    Sn = (a*(r^N - 1))/(r-1);
end

%% Ex 2

function Sn = mySort(x,y)
    if(y == 1)
        for ii = 1:(length(x)-1)
            biggest = x(ii);
            biggest_index = 0;
            for jj = (ii+1):length(x)
                if(x(jj) > biggest)
                    biggest = x(jj);
                    biggest_index = jj;
                end
            end
            if(biggest_index ~= 0)
                temp = x(ii);
                x(ii) = x(biggest_index);
                x(biggest_index) = temp;
            end
            Sn = x;
        end
    end

    if(y == 0)
        for ii = 1:(length(x)-1)
            biggest = x(ii);
            biggest_index = 0;
            for jj = (ii+1):length(x)
                if(x(jj) > biggest)
                    biggest = x(jj);
                    biggest_index = jj;
                end
            end
            if(biggest_index ~= 0)
                temp = x(ii);
                x(ii) = x(biggest_index);
                x(biggest_index) = temp;
            end
            Sn = x(end:-1:1);
        end
    end
end

%% Ex 3

function y = mySmoothing(x,N)
    for ii = 1:(length(x)-N+1)
        sum = 0;
        for jj = ii:N+ii-1
            sum = sum + x(jj);
        end
        y(ii) = sum/N;
    end
end