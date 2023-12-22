function [distance, angle] = simulatePerson()

    % Generate random values using Perlin noise for distance and angle
    noiseScale = 10;  % Adjust the scale of the Perlin noise
    distance = imnoise(zeros(1, 1), 'perlin', noiseScale, 0.5);
    angle = imnoise(zeros(1, 1), 'perlin', noiseScale, 0.5) * 180;

    % Display the generated values
    disp(['Simulated Distance: ' num2str(distance)]);
    disp(['Simulated Angle: ' num2str(angle)]);

    % Plot the generated values
    figure;
    subplot(2, 1, 1);
    plot(distance, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
    title('Simulated Distance');
    xlabel('Observation Index');
    ylabel('Distance');

    subplot(2, 1, 2);
    plot(angle, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
    title('Simulated Angle');
    xlabel('Observation Index');
    ylabel('Angle (degrees)');
    
end