device = 'Dev4';
channel = 'ai0';
sampleRate = 1000;
tiempo_muestras = 60;
archivo_salida = 'datos_emg.csv';

d = daq ("ni");
addinput(d, device, channel, "voltaje");
d.Rate = sampleRate;

timedata = [];     %Almacenar datos tiempo
signaldata = [];   %Almacenas datos de señal

figure ('EMG', 'Señal Tiempo Real', 'Number Title', 'off');
h = plot(NaN, Nan);
xlabel('Tiempo [s]');
ylabel('Voltaje [V]');
title('Señal EMG Tiempo Real');
xlim([0, duration]);
ylim([0, 4]);     %Ajuste rango voltaje
grid on;

disp('Iniciando Adqusisicion');
atarTime = datatime('now');

while seconds (datatime('now') - startTime) < tiempo_muestras

    [data, timestamp] = read(d, "OutputFormat", "Matrix");

    t = seconds(datatime ("now") - startTime);
    timeVec = [timeVec; t];
    signalVec = [signalVec; data];

    set(h, 'XData', timeVec, 'YData', signalVec);
    drawshow;
end

disp('Adquisicion Finalizada. Guardando');
T = table(timeVec, signalVec, 'VariableNames', {'Tiempo [s]', 'Voltaje [mV]'});
writetable(T, outputFile);
disp(['Datos Guardados en: ', outputFile]);

clear d;