function skymask_RAIM11()        
    filePath = 'E:\Softgnss-0311(2)\navSolutionResults.mat';

    % Check if the file exists and load data
    if exist(filePath, 'file')
        navSolutions1 = load(filePath);  
        pseudoranges = navSolutions1.navSolutions.correctedP; % 5x178 matrix
        satellite_positions = navSolutions1.navSolutions.satPositions; % 3x5x178 matrix
    else
        error('File not found: %s', filePath);
    end

    sigma = 3; % Standard deviation of pseudorange measurements

    % Number of epochs
    epochs = size(pseudoranges, 2); % Should be 178
    n = size(pseudoranges, 1); % Should be 5 (number of satellites)

    % Check the size of satellite_positions
    disp(['Size of satellite_positions: ', num2str(size(satellite_positions))]);

    % Iterate through each epoch
    for epoch = 1:epochs
        % Extract pseudoranges and satellite positions for the current epoch
        current_pseudoranges = pseudoranges(:, epoch); % 5x1 vector
        current_sat_positions = satellite_positions(:, :, epoch)'; % Transpose to ensure 5x3 matrix

        % Debug: Check the size of current_sat_positions
        disp(['Epoch ', num2str(epoch), ': Size of current_sat_positions = ', num2str(size(current_sat_positions))]);

        % Ensure current_sat_positions has the correct size
        if size(current_sat_positions, 2) ~= 3 || size(current_sat_positions, 1) ~= 5
            error('Unexpected satellite position size at epoch %d.', epoch);
        end

        % Ensure no missing data
        if any(isnan(current_sat_positions(:)))
            error('Missing satellite position data at epoch %d.', epoch);
        end

        % Plot satellite positions in 3D space
        %figure; % Create a new figure for each epoch
        %scatter3(current_sat_positions(:, 1), current_sat_positions(:, 2), current_sat_positions(:, 3), 'filled');
        %xlabel('X (meters)');
        %ylabel('Y (meters)');
        %zlabel('Z (meters)');
        %title(['Epoch ', num2str(epoch), ': Satellite Positions']);
        %grid on;
        %axis equal;

        % Initialize design matrix A
        A = zeros(n, 4);
        for i = 1:n
            % Access each satellite's position for the current epoch
            sat_position = current_sat_positions(i, :); % This should give a 1x3 vector

            % Compute the unit vector from receiver to satellite
            norm_range = norm(sat_position);
            if norm_range > 0
                A(i, 1:3) = sat_position / norm_range; % Normalize the position
            else
                error('Satellite position has zero length at epoch %d, satellite %d.', epoch, i);
            end
            A(i, 4) = -1; % For the range equation
        end

        % Initial weights (assuming equal weight for all satellites)
        W = eye(n);

        % Compute initial position estimate using WLS
        position = (A' * W * A) \ (A' * W * current_pseudoranges);

        % Compute residuals
        residuals = current_pseudoranges - A * position;

        % Compute variance of residuals
        sigma_r2 = (residuals' * residuals) / (n - 4);

        % Chi-square test for fault detection
        chi_square = (residuals' * W * residuals) / sigma_r2;

        % Define Chi-square critical value for alpha = 0.01
        critical_value = chi2inv(0.99, n - 4);

        % Fault detection
        if chi_square > critical_value
            disp(['Epoch ', num2str(epoch), ': Fault detected in measurements!']);
            % Implement exclusion logic here if needed
        end

        % Compute Protection Level (PL)
        k = chi2inv(0.9999999, 1); % For P_md = 10^-7
        PL = k * sigma;

        % Display results for the current epoch
        disp(['Epoch ', num2str(epoch), ': Estimated Position: ', num2str(position')]);
        disp(['Epoch ', num2str(epoch), ': Protection Level: ', num2str(PL)]);
    end

    % Initialize a single 3D figure
    figure;
    hold on; % Keep adding to the same plot
    grid on;
    xlabel('X (meters)');
    ylabel('Y (meters)');
    zlabel('Z (meters)');
    title('Satellite Positions Across All Epochs');
    axis equal;

    % Number of epochs
    epochs = size(satellite_positions, 3); % Assuming satellite_positions is 3x5x178

    % Define a colormap to vary colors for each epoch
    cmap = parula(epochs); % Generate a colormap with unique colors for each epoch

    % Iterate through each epoch
    for epoch = 1:epochs
        % Extract satellite positions for the current epoch
        current_sat_positions = satellite_positions(:, :, epoch)'; % 5x3 matrix
        % Plot the satellite positions for the current epoch
        scatter3(current_sat_positions(:, 1), current_sat_positions(:, 2), current_sat_positions(:, 3), ...
                  50, cmap(epoch, :), 'filled'); % 50 is the marker size
    end

    % Add a colorbar to indicate epoch indexing
    colormap(cmap);
    c = colorbar;
    c.Label.String = 'Epoch Number';
    clim([1 epochs]); % Scale colorbar to epoch range
    hold off; % Release the hold on the current figure
end