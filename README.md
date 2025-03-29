
# PDS_LAB4 

Para la presente práctica se tuvo como objetivo la toma y análisis de una señal electromiográfica (EMG), la cual se tomo por medio de electrodos, para ser posteriormente analisados por un DAQ cuyos datos seran tomados y guardados a partir de la programación en un código de Matlab, dichos datos a su vez seran posteriormente analisados por medio de un código de phyton que nos brindara información sobre su frecuencia y una comparativa gráfica entre la señal original y otra a la cual se le fueron aplicados filtros para un análisis más preciso del mismo, así como un análsis estadísticos de los datos finales. Todo lo anterior se explicará más a fondo a continuación.


## 1. CIRCUITO Y UBCACIÓN ELECTRODOS

![Image](Imagenes/circuito.jpg)
En esta imagen tenemos el circuto completo armado, el cual esta conformado primeramente por la tarjeta de procesamiento stm32 que esta dandole energia a nuestro modulo AD8232 el cual se maneja con (3.3v), este se utilizo principalmente para captar las señales electromiograficas producidas por el enfuerzo primario el cual era la fuerza del musculo  al extender el brazo o al hacer fuerza  y la fatiga producida por el primer esfuerzo , esta que a su vez fue capatada y guardada para asi mismo analizar la señal y como era el cambio entre el inicio de la fuerza la cual se hizo apretando una dona de 5 kilogramos y la fatiga despues de apretarla repetidamente durante 60 segundos.

![Image](Imagenes/posicion1.jpg)
Posteriormente esta la portura de cada uno de los electrodos los cuales fueron tres, el verde que esta en la siguiente imagen el cual es la tierra y los otros dos (rojo y el amarillo) que son los resposables de cada derivacion tanto dertecha como izquierda , estos fueron colocados especificamnete donde la irrigacion o fuerza del musculo, en este caso se sentia mas que en otra parte del antebrazo asi mismo el electrodo derecho que era el rojo se corrio un poco para evitar que tomara o hubiera una interrupcion de la señal por el pulso cardiaco ya que en esta parte del antebrazo pasan venas donde se puede tomar el pulso.

![Image](Imagenes/posicion2.jpg)
Aca encontramos ya el eletrodo verde que este fue nuestra referencia de tierra el cual se puso en la parte anterior del brazo debajo del codo para asi mismo evitar la interrupcion de la señal por otras fuentes como el pulso cardico o un movimento brusco que dañara la señal o despegara el electrodo.

![Image](Imagenes/todo.jpg)
Por último es la conexion total de nuestro cicuito junto los electrodos puestos correctamnete en cada uno de los lugares escogidos y el DAQ el cual fue el que nos permitio captar la señal de la fuerza y fatiga del musculo con el modulo AD8232, guardando la señal y perimitiendo verla en mathlab y asi mismo  ya filtrada en python con sus respectivas graficas.

## 2. TOMA Y GUARDADO SEÑALES EMG EN MATLAB

### a. Configuración del DAQ

    device = 'Dev5';          % Nombre DAQ
    channel = 'ai0';          % Canal entrada
    sampleRate = 1000;        % Frecuencia muestreo
    tiempo_muestras = 60;     % Duración
    archivo_salida = 'emgsignall.csv';  % Archivo salida

    d = daq ("ni");                                
    addinput(d, device, channel, "voltaje");  %Agregar Canal
    d.Rate = sampleRate;


Primero, iniciamos definiendo los parámetros básicos para la adquisición de datos por parte de los electrodos, donde "Dev4" identifica el DAQ y "ai0" se refiere al canal analógico de entrada del mismo; adicionalmente, se delimitó la frecuencia de muestreo en 1kHz, valor que es óptimo teniendo en cuenta las altas frecuencias de la actividad muscular en nuestro cuerpo; tras esto se delimito la toma de datos a un minuto y el archivo "emg_signal" es el encargado de integrar los datos en ese minuto; por último, "addinput" configura nuestro canal seleccionado para medir el voltaje.

### b. Variable y Gráfica en tiempo real

    %Variables
    timedata = [];     %Almacenar datos tiempo
    signaldata = [];   %Almacenas datos de señal

    %Gráfica
    figure ('EMG', 'Señal Tiempo Real', 'Number Title', 'off');
    h = plot(NaN, Nan);
    xlabel('Tiempo [s]');
    ylabel('Voltaje [V]');
    title('Señal EMG Tiempo Real');
    xlim([0, duration]);
    ylim([0, 4]);          %Ajuste rango voltaje
    grid on;

    disp('Iniciando Adqusisicion');
    atarTime = datatime('now');

![Image](Imagenes/matlab.png)

Las variables creadas (time - signal), sirven para almacenar tanto los datos temporales como los de amplitud. Una vez definidas, se prepara la visualización dinámica, cabe resaltar límites de rango, ya que si es demasiado grande podria o pequeña podria generar una dificultad en la visualización de la señal tomada. Tal como se muestra en la imágen se muestra se ven llos rangos de lo ejes estaablecidos con anterioridad, junto con la señal EMG tomada por los electrodos.

### c . Bucle de Adquisición y Guardado de Datos

    while seconds (datatime('now') - startTime) < tiempo_muestras

    %Leer Muestra
    [data, timestamp] = read(d, "OutputFormat", "Matrix");

    %Guardar Datos
    t = seconds(datatime ("now") - startTime);
    timeVec = [timeVec; t];
    signalVec = [signalVec; data];

    %Actualizar Gráfica
    set(h, 'XData', timeVec, 'YData', signalVec);
    drawshow;

    end

    %Guardar Datos
    disp('Adquisicion Finalizada. Guardando');
    T = table(timeVec, signalVec, 'VariableNames', {'Tiempo [s]', 'Voltaje [mV]'});
    writetable(T, outputFile);
    disp(['Datos Guardados en: ', outputFile]);

    clear d;

Se prosigue con un bucle de un minuto, valor establecido en la configuración, donde se capturan los datos en un formato matricial, en donde se calcula el tiempo transcurrio con "datetime", almacenando los datos de los vectores; junto con las actualizaciones dinámicas permite el monitoreo de la señal en tiempo real, sin retrasos. Al final, los datos se guardan en una tabla excel de nombre "emg_signal.csv", delimitando los tiempos y voltajes en columnas respectivamente, el uso de "writetable" permite la compatibilidad con excel tanto con phyton, para su posterior análsis.

### d. SEÑAL FILTRADA VS LA ORIGINAL- VENTANA DE HAMMING

     plt.figure(figsize=(10, 4))
     plt.plot(tiempo, voltaje, label="Señal Original", alpha=0.5, color="gray")
     plt.plot(tiempo, filtered_signal, label="Señal Filtrada", color="blue")
     plt.xlabel("Tiempo (s)")
     plt.ylabel("Voltaje (V)")
     plt.title("Señal EMG antes y después del filtrado")
     plt.legend()
     plt.grid(True)
     plt.show()

Aca ya tenemos la visualizacion  tanto de la señal1 que es la  original esta es de coloir  (gris) y contiene ruido este es un sonido molesto o no deseado tambien teine un artefacto que es una distorsión o error en una imagen o es te caso sonido, la señal 2 que es la 
señal filtrada de solor (azul) esta ya es una señal mas limpia, ya que esta conserva los  componentes relevantes de frecuencia en (20-60 Hz).

     window_size = 1  # 1 segundo por ventana
     samples_per_window = int(window_size * fs_mean)
     windows = [filtered_signal[i * samples_per_window:(i + 1) * samples_per_window] 
           for i in range(num_windows)]
     windowed_signals = [w * np.hamming(len(w)) for w in windows]

La ventana ya fue hecha a partir de primero samples_per_window que es el número de muestras de tiempo que fue en un 1 segundo, windows esta es la que divide la señal en segmentos de tiempon tambien en un 1 segundo y np.hamming() que es la que aplica la  ventana de Hamming para reducir fugas espectrales en FFT que son los errores que se producen cuando se analizan segmentos de señales que no coinciden con un número entero de ciclos. 


## 3. PROGRAMACIÓN EMG EN PYTHON
### a. librerias utilizadas 

     import pandas as pd
     import numpy as np
     import matplotlib.pyplot as plt
     from scipy.signal import butter, filtfilt

En esta sección tenemos las librerias utlizadas en nuestro codigo de python empezando por  pandas (pd)esta fue utilizada para cargar y manipular datos desde un archivo CSV el cual es un archivo de texto que almacena datos separados por comas, despues tenemos la libreria numpy (np) esta es la encargada de proporcionar operaciones matemáticas y manejo de arreglos en ella, matplotlib.pyplot (plt) esta se ulizo ya que esta nos permite la  visualización de gráficos y las ultimas dos que son scipy.signal.butter la cual su funcion es el diseño de filtros Butterworth que son los filtros pasa-bajos y pasa-altos y scipy.signal.filtfilt que esta es la libreria que aplica un  filtrado sin distorsión de fase.

### b. CARGA DE DATOS, EXTRANCCION DE SEÑAL Y ESTIMULACION EN LA FRECUENCIA DE MUESTREO 

     file_path = "emg_signal.csv"  
     df = pd.read_csv(file_path)
     tiempo = df.iloc[:, 0]  # Primera columna (Tiempo)
     voltaje = df.iloc[:, 1]  # Segunda columna (Voltaje)

     fs_estimates = 1 / tiempo.diff().dropna().unique()
     fs_mean = fs_estimates.mean()

La carga de datos y extranccion de señal se hizo apartir de primero pd.read_csv el cual es el encargdo de cargar el archivo CSV en un DataFrame (df) este es una estructura de datos bidimensional que se usa en para organizar y analisar los datos , despues de utilizo df.iloc[:, 0] este es el encargdo de extraer la primera columna de tiempo en  (tiempo - segundos) y por ultimo df.iloc[:, 1]el cual extrae la segunda columna que es la columna encargda del (voltaje de la señal EMG)desde el modulo AD8232.

Para la estimulacion de la frecuencia tenemos tiempo.diff() este es el que permite calcular las diferencias entre muestras consecutivas que son los (intervalos de tiempo), dropna() este es el que elimina valores NaN (primera diferencia no existe) valores que por lo general no son numeros, unique() este es el que elimina duplicados osea elimina los intervalos constantes que identifica, 1 / ..  este convierte intervalos en frecuencias (Hz) y fs_mean el cual promedia las frecuencias estimadas (Hz).

### c. SEÑAL ORIGINAL, DISEÑO Y APLICACION DE LOS FILTROS 

     plt.figure(figsize=(10, 4))
     plt.plot(tiempo, voltaje, label="Señal EMG", color="b")
     plt.xlabel("Tiempo (s)")
     plt.ylabel("Voltaje (V)")
     plt.title("Señal EMG Original")
     plt.legend()
     plt.grid(True)
     plt.show()
Para la señal original se utilizo plt.plotesta es la que grafica la señal EMG en el dominio del tiempo, plt.xlabel y  plt.ylabel este es el encargado de etiquetar los ejes y plt.grid este es el que nos permite mostrar una cuadrícula para una mejor lectura.

### DISEÑO

     def butterworth_filter(data, cutoff, fs, filter_type, order=4):
     nyquist = 0.5 * fs  # Frecuencia de Nyquist
     normal_cutoff = cutoff / nyquist
     b, a = butter(order, normal_cutoff, btype=filter_type, analog=False)
     return filtfilt(b, a, data)

Aca tenemos nyquist = 0.5 * fs el cual se encarga de calcular la frecuencia de Nyquist (máxima frecuencia detectable) en nuestra muestra, normal_cutoff = cutoff / nyquist que esta ayuda a normalizar la frecuencia de corte, butter() enarcagda de diseñar coeficientes del filtro Butterworth que son los pasa altos- pasa bajos y filtfilt() que aplica un filtrado sin retraso de fase el cual es (bidireccional).
### APLICACION 

     filtered_high = butterworth_filter(voltaje, 20, fs_mean, 'high')  # Pasa-altas (20 Hz)
     filtered_signal = butterworth_filter(filtered_high, 60, fs_mean, 'low')  # Pasa-bajas (60 Hz)
     
Aca tenemos la aplicacion de los filtros butterworth que como se dijo antes son dos el primerp Filtro pasa-altas (20 Hz) este es el que elimina los componentes de baja frecuencia (artefactos de movimiento) y el segundo que es el filtro pasa-bajas (60 Hz) este ya suaviza como tal la señal, lo hace eliminando ruido de altas frecuencias.

### d. SEÑAL FILTRADA VS LA ORIGINAL- VENTANA DE HAMMING


## 4. GRAFICACION PYTHON: ANÁLISIS, FILTRADO Y GRAFICACIÓN DE SEÑAL

![EMG_original](https://github.com/user-attachments/assets/5e4ab7ad-4fce-4747-b4f6-7c01121dbe9a)

Esta gráfica representa una señal de electromiografia en tiempo real, en la parte del eje Y se representa el voltaje el cual oscila aproximadamente  entre 0 v y 2.5 v lo que sugiere contracción musculares y en el eje X el tiempo el  cual se mide a lo largo de 60  segundos lo que permitió una captura completa de la contracción muscular, esta señal tiene una variación de amplitud lo cual refleja actividad muscular moderada, esta representa una componente de alta frecuencia lo cual es característico de las señales EMG ya que se activan varias fibras del musculo y se genera la contracción, también se puede ver una caída en el eje X cuando esta en 20 segundos ya que esto representa relajación del musculo.


![Espectro_EMG](https://github.com/user-attachments/assets/15f900cc-3b14-41c6-8c2f-052029591fe2)

Esta grafica representa como se distribuyen las diferentes frecuencias en la señal donde se puede evidenciar la aplicación de  5 ventanas de análisis  para obtener el comportamiento espectral en distintos segmentos de tiempo, en el eje X se encuentra la frecuencia en Hz que va desde o Hz hasta 70 Hz y en el eje Y se tiene la magnitud la cual representa la intensidad relativa de cada componente, la mayor parte de la energía se encuentra entre los 20 Hz y los 60 Hz lo cual concuerda a las señales musculares, cada ventana presenta variaciones pequeñas en las frecuencias mas dominantes por lo que se puede decir que hay cambios en la activación muscular a lo largo del tiempo, la ventana roja y morada presentan picos mas altos entre los 30Hz y los 40 Hz por lo que se puede decir que están relacionadas con las contracciones musculares mas intensas

![Filtrada](https://github.com/user-attachments/assets/4caf6e03-565a-4b94-974a-910b5f742c92)

Esta gráfica compara la señal de la electromiografia, la primera es la señal original los cuales son datos sin ningún tipo de proceso tanto ruido como amplitud y la segunda es la señal filtrada los cuales ya son datos procesados con reducción de ruido, en el eje X se presenta el tiempo en segundos el cual dura 60 segundos y en el eje Y se presenta el voltaje donde se puede ver la reducción en la amplitud de la señal después del filtrado, comparando el antes y el después del filtrado, la original tiene un desplazamiento positivo el cual me mantiene en 1.5 V y la señal filtrada esta centrada en 0 V lo que indica que tiene filtros; la señal original tiene picos altos y caída muy largas por lo que con el filtrado los picos han disminuido 


![Hamming](https://github.com/user-attachments/assets/00ace864-3fef-4038-ac92-0c5b4c8f3bc0)

Esta gráfica representa señales procesadas con una ventana de Hamming por lo que indica que se aplico una técnica de segmentación y suavizado en la señal, en el eje X se presentan las muestras que son los puntos de cada ventana analizada y en el eje Y se presenta el voltaje el cual esta en un rango de -0.2 V y 0.2 V donde esta presenta la variación de la señal en cada ventana donde cada ventana tiene un color para su identificación, la ventana de Hamming permite observar como la señal de la EMG  se comporta en fragmentos de tiempo específicos aparte de esto se conserva información clave sobre la actividad muscular mientras este reduce efectos que no se desean, es importante que tenga una amplitud moderada ya que es lo que se espera de una señal filtrada 



## 4. ANÁLISIS ESTADÍSTICO DE LA SEÑAL

