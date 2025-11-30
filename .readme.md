# PhyschLiquid — Simulação de Partículas com CUDA C++

Mini projeto para simulação de partículas usando CUDA C++ (cálculo de posições/velocidades na GPU) e visualização em Python (matplotlib). Útil para estudar paralelismo em GPU e física básica de partículas.

## Requisitos
- Linux com GPU NVIDIA e CUDA Toolkit compatível
- nvcc (CUDA) e g++
- Python 3
- Bibliotecas Python: `matplotlib`, `pandas`

Instalação rápida (Ubuntu/Debian):

# Como Rodar
## Compilar a simulação CUDA

Abra o terminal na pasta do projeto:

```nvcc main.cu -o main```

Isso vai gerar o executável main.


## Rodar a simulação

```./main```


## Visualizar um frame:

```python3 viewPhysch.py```
