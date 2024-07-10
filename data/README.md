# Base de Datos para Simulaciones en Cell-Free Massive MIMO

Este documento explica cómo identificar y entender los diferentes elementos dentro de la base de datos utilizada para almacenar los resultados de simulaciones en sistemas Cell-Free Massive MIMO. La base de datos utiliza un esquema de nombres de archivo para organizar los resultados.

## Esquema de Nombres de Archivo

Los nombres de los archivos de resultados siguen un formato específico que permite identificar rápidamente la configuración de cada simulación. Los formatos de nombres son:

1. `UP_WR_<AP>AP_<ANT>ANT_<MEDIO>M_<USER>K_dist_usuarios_60_40.mat`
2. `MR_WR_<AP>AP_<ANT>ANT_<MEDIO>M_<USER>K.mat`
3. `UP_SWR_<AP>AP_<ANT>ANT_<MEDIO>M_<USER>K_dist_usuarios_60_40.mat`
4. `MR_SWR_<AP>AP_<ANT>ANT_<MEDIO>M_<USER>K.mat`

### Componentes del Nombre de Archivo

Cada parte del nombre de archivo corresponde a un parámetro de la simulación:

- **`<AP>`**: Número de puntos de acceso (Access Points).
  - Valores posibles: 100, 400

- **`<ANT>`**: Número de antenas por punto de acceso.
  - Valores posibles: 4, 1

- **`<MEDIO>`**: Parámetro del medio de transmisión utilizado en la simulación.
  - Valores posibles: 1000, 500, 100

- **`<USER>`**: Número de usuarios presentes en la simulación.
  - Valores posibles: 40, 80, 150

### Escenarios

- **`WR`**: Escenario No Acotado (Con Wrap Around).
- **`SWR`**: Escenario acotado (Sin Wrap Around).

### Tipo de Precodificación

- **`MR`**: Precoding Matched Filter (MR).
- **Sin `MR`**: Precoding MMSE (PMMSE).

### Ejemplos de Nombres de Archivos

1. `UP_WR_100AP_4ANT_1000M_40K_dist_usuarios_60_40.mat`
   - Puntos de acceso: 100
   - Antenas por punto de acceso: 4
   - Medio de transmisión: 1000
   - Número de usuarios: 40
   - Escenario: No acotado (Wrap Around)
   - Precoding: PMMSE

2. `MR_WR_400AP_1ANT_500M_80K.mat`
   - Puntos de acceso: 400
   - Antenas por punto de acceso: 1
   - Medio de transmisión: 500
   - Número de usuarios: 80
   - Escenario: No acotado (Wrap Around)
   - Precoding: MR

3. `UP_SWR_100AP_4ANT_1000M_150K_dist_usuarios_60_40.mat`
   - Puntos de acceso: 100
   - Antenas por punto de acceso: 4
   - Medio de transmisión: 1000
   - Número de usuarios: 150
   - Escenario: Acotado (Sin Wrap Around)
   - Precoding: PMMSE

4. `MR_SWR_400AP_1ANT_100M_40K.mat`
   - Puntos de acceso: 400
   - Antenas por punto de acceso: 1
   - Medio de transmisión: 100
   - Número de usuarios: 40
   - Escenario: Acotado (Sin Wrap Around)
   - Precoding: MR

### Identificación de Configuraciones

Las combinaciones de configuraciones almacenadas en la base de datos se generan bajo ciertas condiciones específicas. Por ejemplo:

- **100 puntos de acceso, 4 antenas, medio de transmisión 1000, usuarios 40, 80 o 150.**
- **400 puntos de acceso, 1 antena, medio de transmisión 1000, usuarios 40, 80 o 150.**
- **100 puntos de acceso, 4 antenas, medio de transmisión 500, usuarios 40.**
- **400 puntos de acceso, 1 antena, medio de transmisión 500, usuarios 40.**
- **100 puntos de acceso, 4 antenas, medio de transmisión 100, usuarios 40.**
- **400 puntos de acceso, 1 antena, medio de transmisión 100, usuarios 40.**

Estas combinaciones permiten realizar simulaciones específicas y guardar los resultados de manera organizada y fácilmente identificable.

## Conclusión

El esquema de nombres de archivo utilizado en esta base de datos facilita la identificación rápida de la configuración de cada simulación de Cell-Free Massive MIMO. Esta estructura asegura una gestión eficiente de los resultados y optimiza el acceso a los datos relevantes para análisis y estudios posteriores.
