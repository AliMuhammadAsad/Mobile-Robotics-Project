load officemap.mat
OfficeMap = binaryOccupancyMap(map)
show(OfficeMap)
% % Define the binary occupancy grid map
% map = binaryOccupancyMap(10,10,5);
% setOccupancy(map,[1 1; 1 2; 2 1; 2 2; 3 3; 3 4; 4 3; 4 4],1);

% Define the start and goal points
start = [100 100];
goal = [700 1300];
% goal1 = fliplr(goal);


% Define the A* path planner object
planner = plannerAStarGrid(OfficeMap);

% Define the path
path = plan(planner, start, goal);

% Plot the path
show(planner)
hold on
plot(path(:,2),path(:,1),'r','LineWidth',2)
% hold off

% Plot waypoints on the path
numWaypoints = 10;
waypoints = interpolatePath(path, numWaypoints);
% figure
plot(waypoints(:, 2), waypoints(:, 1), 'bo', 'MarkerSize', 8, 'LineWidth', 1)
hold off

function waypoints = interpolatePath(path, numWaypoints)
    % Linearly interpolate between points on the path
    distances = cumsum([0; sqrt(diff(path(:, 1)).^2 + diff(path(:, 2)).^2)]);
    totalDistance = distances(end);
    
    % Interpolate
    interpDistances = linspace(0, totalDistance, numWaypoints);
    waypoints(:, 1) = interp1(distances, path(:, 1), interpDistances, 'linear');
    waypoints(:, 2) = interp1(distances, path(:, 2), interpDistances, 'linear');
    disp('Waypoints Coordinates:');
    disp(waypoints);
end


