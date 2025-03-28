# PDS_LAB4 

Para la presente práctica se tuvo como objetivo la toma y análisis de una señal electromiográfica (EMG), la cual se tomo por medio de electrodos, para ser posteriormente analisados por un DAQ cuyos datos seran tomados y guardados a partir de la programación en un código de Matlab, dichos datos a su vez seran posteriormente analisados por medio de un código de phyton que nos brindara información sobre su frecuencia y una comparativa gráfica entre la señal original y otra a la cual se le fueron aplicados filtros para un análisis más preciso del mismo, así como un análsis estadísticos de los datos finales. Todo lo anterior se exlicará mas a fondo a continuación.

## 1. TOMA Y GUARDADO SEÑALES EMG EN MATLAB

### a. Configuración del DAQ
    device = 'Dev4';          % Nombre del dispositivo DAQ
    channel = 'ai0';          % Canal de entrada analógica
    sampleRate = 1000;        % Frecuencia de muestreo (1 kHz)
    tiempo_muestras = 60;     % Duración de la adquisición (60 segundos)
    archivo_salida = 'datos_emg.csv';  % Archivo de salida para los datos

