# Guía de Uso del Live Script para Simulaciones de Cell-Free Massive MIMO

Este archivo `README.md` proporciona instrucciones detalladas sobre cómo ejecutar el Live Script `Main.mlx`, que está diseñado para simular y analizar diferentes configuraciones de redes Cell-Free Massive MIMO utilizando MATLAB.

## Requisitos Previos
Asegúrate de tener una versión compatible de MATLAB instalada, preferiblemente MATLAB R2020a o superior, dado que utiliza funcionalidades específicas de Live Scripts.

## Configuración Inicial
Antes de ejecutar el script, es importante configurar correctamente el entorno:
1. **Clonar el repositorio**: Asegúrate de tener una copia local del repositorio que incluye todas las carpetas necesarias (`/src`, `/data`, `/docs`, `/results`).
2. **Datos Predeterminados**: Una base de datos predeterminada está incluida en la carpeta `/data`. Si deseas realizar simulaciones con nuevos datos sin sobrescribir los existentes, cambia la carpeta de destino en el script.

## Ejecución del Live Script
1. **Abrir el Script**: Navega a la carpeta `/src` y abre el archivo `main.mlx` con MATLAB.
2. **Ejecutar el Script**: Puedes ejecutar el Live Script completo utilizando el botón de ejecución en MATLAB. El script está segmentado en secciones que pueden ser ejecutadas independientemente para verificar resultados parciales.
3. **Visualización de Resultados**: Las figuras y gráficos se generan automáticamente y se guardan en la carpeta `/results` como especificado en el script.

## Descripción del Script
El script `main.mlx` está organizado en varias secciones principales:
- **Preparación del Entorno**: Limpieza de variables y figuras, y preparación de carpetas.
- **Simulación de Escenarios usando P-MMSE y MR**: Configuración y ejecución de simulaciones para diferentes configuraciones de APs, antenas, y distancias.
- **Carga y Procesamiento de Resultados**: Análisis de los datos generados, incluyendo cálculo de CDF y otras métricas relevantes.
- **Generación de Gráficos**: Códigos para la creación y almacenamiento de figuras representativas de los resultados de las simulaciones.

## Notas Adicionales
- **Modificación de Parámetros**: Para modificar parámetros de simulación como el número de APs o antenas, ajusta los vectores correspondientes al inicio del script.
- **Reutilización de Datos**: Para evitar la sobrescritura de datos existentes, modifica las rutas de los directorios de guardado dentro del script antes de ejecutar simulaciones con nuevos parámetros.

Este script ofrece una herramienta integral para la exploración y análisis de tecnologías de telecomunicaciones avanzadas, permitiendo a investigadores y estudiantes profundizar en el estudio de sistemas Cell-Free Massive MIMO.

