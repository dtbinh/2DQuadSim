% 7/30/13
% plotTraj.m
% plots a given trajectory
% Dependencies: -
%
% inputs: 
%   xT: (n+1) x m x d matrix, where row i contains the ith coefficient for the
%       jth trajectory in dimension k, nondimensionalized in time 
%   n: integer, order of desired trajectory
%   m: integer, number of pieces in trajectory
%   d: integer, number of dimensions
%   tDes: (m+1)x1 vector, desired time of arrival at each keyframe
%   posDes: r x (m+1) x d matrix, 
%       where each row i is the value the (i-1)th derivative of keyframe j for dimensions k 
%   dt: real value, desired time intervals to plot with
%   dimLabels: mx1 cell, create legend labels for dimensions,
%   plotDim: nxm matrix, creates n plots of column 1 vs. column 2
% outputs:
%   figure plotting trajectory


function [] = plotTraj(xT, n, m, d, tDes, posDes, dt, dimLabels, plotDim)

t = 0:0.01:tDes(m+1); %construct t vector 
t = t';
pos = zeros(length(t), d); %holds position at time i for dimension d

% evaluate the piece-wise polynominal at each point in time
for i = 1:length(t),
    % if before first keyframe time, assume at initial position
    if (t(i, 1) < tDes(1, 1)),
        % evaluate in each dimensions
        for k = 1:d
            pos(i, k) = polyval(xT(:, 1, k), 0); 
        end

    % find which piece of the trajectory we're on based on time and
    %   evaluate there
    elseif (t(i, 1) < tDes(m+1, 1));
        
        for j = 1:m,
            if (t(i, 1) < tDes(j+1, 1));
                scaledt = (t(i, 1)-tDes(j, 1))/(tDes(j+1, 1)-tDes(j, 1)); % find the nondimensionalized time
                
                % evaluate in each dimension
                for k = 1:d,
                    pos(i, k) = polyval(xT(:, j, k), scaledt); 
                end
                
                break;
            end
        end
        
    % if after the final keyframe time, assume hover at final keyframe position
    else
        
        % evaluate in each dimension
        for k = 1:d
            pos(i, k) = polyval(xT(:, m, k), 1); 
        end
    end
end



for i = 1:d,
figure()
hold on;
plot(t, pos(:, i));
plot(tDes, posDes(1, :, i), 'k^');
xlabel('time (s)');
ylabel(dimLabels{i});
end

[extraPlots, ~] = size(plotDim);
for i = 1:extraPlots,
figure()
hold on;
plot(pos(:, plotDim(i, 1)), pos(:, plotDim(i, 2)));
plot(posDes(1, :, 1), posDes(1, :, 2), 'k^');
xlabel(dimLabels{plotDim(i, 1)});
ylabel(dimLabels{plotDim(i, 2)});
end



end

