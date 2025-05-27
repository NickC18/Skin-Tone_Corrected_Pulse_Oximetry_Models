% ====================================================================
% DatasetDescirption.m
% Paper: Skin-Tone Corrected Pulse Oximetry Models Evaluated through
% Reflective Pulsatile Monte Carlo Simulaitons
% Authors: Yan Tung Nicholas Chan, Megh Rathod, Daniel Franklin
% Repository:
% github.com/NickC18/Skin-Tone_Corrected_Pulse_Oximetry_Models
% ====================================================================

% Overview
% Figure1.mat - Overview of Optical Parameters
% Figure2.mat - Parameter Fine-Tuning
% Figure3.mat - Ratio-of-Ratios Calcuulations and Melanin-SpO2 Sweep
% Figure4.mat - Quantifying and Addressing Skin-Tone Bias
% FigureS1.mat - Convergence Analysis of Simulated Reflectance
% FigureS2.mat - Absorption Coefficient of Skin Chromophores

%% -------------------------------------------------------------------

% Figure1.mat
% wavelength (nm)               [1 x 601] double
% optical_properties            [6 x 4 x 601] double
%     Axes: (skin_layer, property, wavelength)
%     skin_layer         property
%     ------------------------------------
%       1 EP        1 diastolic mua (1/mm)
%       2 CL        2 systolic mua (1/mm)
%       3 UP        3 mus (1/mm)
%       4 RD        4 g
%       5 DP
%       6 SC
%     ------------------------------------
% Sample Plot: Diastolic Absoprtion Coefficient (Figure 1c)
load Figure1.mat
figure
semilogy(wavelength, squeeze(optical_properties(:,1,:)), 'LineWidth', 2)
xlabel('Wavelength (nm)')
ylabel('Absorption Coefficient (1/mm)')
set(gca,'FontSize',11,'FontWeight','b')

%% -------------------------------------------------------------------

% Figure2.mat
% melanin (volume fraction)     [1 x 20] double
% sim_wavelength (nm)           [1 x 601] double
% sim_reflectance (%)           [2 x 20 x 601] double
%     Axes = [epidermis_scattering, melanin, sim_wavelength]
%     epidermis_scattering
%     -----------------------------------------
%       1 without melanin dependent scattering
%       2 with melanin dependent scattering
%     -----------------------------------------
% ep_scattering (%)             [20 x 601] double
%     Axes = [melanin, sim_wavelength]
% exp_wavelength (nm)           [1 x 1372] double
% exp_reflectance (%)           [3 x 1372] double
%     Axes = [skin_colour, exp_wavelength]
%     skin_colour
%     ----------------
%       1 Light
%       2 Medium
%       3 Dark
%     ----------------
% Sample Plot: With Melanin Dependent Scattering (Figure 2c)
melanin_colour = [255 219 172; 241 194 125; 224 172 105; 198 134 66;
                  141 85 36] ./ 256;
melanin_colour = repelem(melanin_colour, 4, 1);
colour = [melanin_colour; repelem([0 0.5 0.5], 3, 1)];
load Figure2.mat
figure
hold on
plot(sim_wavelength, squeeze(sim_reflectance(2,:,:)), 'LineWidth', 2)
plot(exp_wavelength, exp_reflectance, 'LineWidth', 2)
hold off
ylim([0 50])
xlabel('Wavelength (nm)')
ylabel('Reflectance (%)')
set(gca,'FontSize',11,'FontWeight','b','ColorOrder',colour)

%% -------------------------------------------------------------------

% Figure3.mat
% melanin (volume fraction)     [1 x 20] double
% SpO2 (%)                      [1 x 11] double
% wavelength (nm)               [1 x 601] double
% refelctance (%)               [2 x 20 x 601] double
%     Axes: (state, melanin, wavelength)
%     state
%     ------------
%       1 Diatole
%       2 Systole
%     ------------
% ACDC (with SpO2 = 50%)        [2 x 20] double
%     Axes: (RoR_wavelength, melanin)
%     RoR_wavelength
%     ---------------
%       1 655 (nm)
%       2 940 (nm)
%     ---------------
% ACDC_fitting_function         [1 x 2] cell
%     Axes: (RoR_wavelength)
% R                             [20 x 11] double
%     Axes: (melanin, SpO2)
% Sample Plot: Melanin's Effects on Ratio-of-Ratios (Figure 3e)
SpO2_colour = [0 144 189; 32 178 170; 102 205 170; 144 238 144;
               50 205 50] ./ 256;
SpO2_colour = repelem(SpO2_colour, 2, 1);
SpO2_colour = [SpO2_colour(1:5, :); 0.3984 0.8008 0.6641;
               SpO2_colour(6:10, :)];
load Figure3.mat
figure
plot(melanin.*100, R, '-', 'Marker', '.', 'MarkerSize', 18, 'LineWidth', 2)
xlim([0 21])
xlabel('Melanin (%)')
ylabel('R')
set(gca,'FontSize',11,'FontWeight','b','ColorOrder',SpO2_colour)

%% -------------------------------------------------------------------

% Figure4.mat
% melanin (volume fraction)     [1 x 20] double
% SpO2 (%)                      [1 x 11] double
% R                             [20 x 11] double
%     Axes: (melanin, SpO2)
% SpO2_model                    [1 x 2] cell
%     Axes: (model_type)
%     model_type
%     ---------------------------------------
%       1 Conventional Ratio-of-Ratios
%       2 Proposed Skin-Tone Corrected Model
%     ---------------------------------------
% abs_error (%)                 [2 x 20 x 11] double
%     Axes: (model_type, melanin, SpO2)
% Sample Plot - Multiple Curve Fitting with Proposed Model (Figure 4d)
colour = [melanin_colour; melanin_colour(1, :)];
x = linspace(0, 2.5, 1000);
load Figure4.mat
figure
hold on
scatter(R, SpO2.*100, 18, 'filled')
plot(x, SpO2_model{2}(x).*100, 'LineWidth', 2)
hold off
xlim([0 2])
ylim([50 100])
xlabel('R');
ylabel('SpO2 (%)');
set(gca,'FontSize',11,'FontWeight','b','ColorOrder',colour)
% Sample Plot - Corresponding Error Map (Figure 4e)
figure
h = heatmap(SpO2.*100, melanin.*100, squeeze(abs_error(2,:,:)).*100);
h.XLabel = 'SpO2 (%)';
h.YLabel = 'Melanin (%)';
h.NodeChildren(3).YDir='normal';
set(findall(gcf,'-property','FontSize'),'FontSize',11)

%% -------------------------------------------------------------------

% FigureS1.mat
% wavelength (nm)               [1 x 601] double
% refelctance (%)               [5 x 601] double
%     Axes = [photon_count, wavelength]
%     photon_count
%     -------------
%       1 1e4
%       2 1e5
%       3 1e6
%       4 1e7
%       5 1e8
%     -------------
% Sample Plot - Simulated Diffuse Reflectance with 1e8 photons (Figure S1c)
load FigureS1.mat
figure
hold on
plot(wavelength, reflectance(5, :) .* 1e2, 'LineWidth', 2)
hold off
ylim([0 50])
xlabel('Wavelength (nm)')
ylabel('Reflectance (%)')
hold off
set(gca,'FontSize',11,'FontWeight','b')

%% -------------------------------------------------------------------

% FigureS2.mat
% wavelength (nm)               [1 x 601] double
% absorption_coefficient (1/mm) [5 x 601] double
%     Axes = [chromophore, wavelength]
%     chromophore
%     -------------
%       1 HbO2
%       2 Hb
%       3 melanin
%       4 water
%       5 fat
%     -------------
% Sample Plot - Absorption Coefficient of Skin Chromophores (Figure S2a)
load FigureS2.mat
figure
semilogy(wavelength, absorption_coefficient, 'LineWidth', 2)
xlabel('Wavelength (nm)')
ylabel('Absorption Coefficient (1/mm)')
set(gca,'FontSize',11,'FontWeight','b')
