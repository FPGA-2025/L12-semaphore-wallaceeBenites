# Geração de Trace para Sinalização Semafórica

A verificação do semáforo é realizada através da comparação dos estados ao longo dos ciclos de clock. O script `generate_trace.py` é responsável por gerar este trace, simulating a execução do semáforo ao longo do tempo e criando pressionamentos aleatórios do botão de pedestre.

## Utilização do Script

Para utilizar o script, execute o seguinte comando:
```bash
python generate_trace.py
```

Serão gerados três arquivos:

- `semaphore_expected.txt`: contém os estados esperados.
- `pedestrian_input.txt`: contém os valores do botão de pedestre em cada ciclo de clock.
- `combined_trace.txt`: combina os dois anteriores.

O arquivo a ser utilizado pelo testbench (tb) é o `combined_trace.txt`. Basta renomeá-lo para `teste.txt` e rodar o tb com:
```bash
iverilog -o tb *.v
./tb
```

## Configuração do Script

No script, você pode configurar as seguintes constantes:

- **CLK_FREQ**: Frequência do clock (em Hz). Deve ser pelo menos 4. Este valor deve corresponder à frequência definida no testbench.
- **SIM_CYCLES**: Tamanho da simulação em ciclos de clock. O máximo é 1020 ciclos.
- **RANDOM_PEDESTRIAN**: Se o botão de pedestre deve ser pressionado aleatoriamente (True/False).
- **PEDESTRIAN_PROB**: Probabilidade do botão de pedestre ser pressionado em cada ciclo, se `RANDOM_PEDESTRIAN` for True.

### Exemplo de Configuração

```python
CLK_FREQ = 4    # Frequência mínima é 4 Hz. Deve corresponder à configuração no testbench.
SIM_CYCLES = 200
RANDOM_PEDESTRIAN = True
PEDESTRIAN_PROB = 0.25
```
