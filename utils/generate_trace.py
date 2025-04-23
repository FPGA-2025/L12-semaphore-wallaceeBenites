import random

# Configurações
CLK_FREQ = 4  # pelo menos 4
SIM_CYCLES = 200
RANDOM_PEDESTRIAN = True
PEDESTRIAN_PROB = 0.25

# Temporizações
SECOND = CLK_FREQ
OPENING_TIME = 5 * SECOND
CLOSING_TIME = 7 * SECOND
CLOSING_BLINK = SECOND // 2

# Estados codificados
CLOSED  = '100'  # red
OPEN    = '001'  # green
CLOSING = '010'  # yellow

# Inicializações
expected_states = []
pedestrian_inputs = []
combined_trace = []

state = CLOSED
counter = 0

for cycle in range(SIM_CYCLES):
    if RANDOM_PEDESTRIAN:
        pedestrian = random.random() < PEDESTRIAN_PROB
    else:
        pedestrian = (cycle in [20, 45, 90, 120, 150])
    pedestrian_inputs.append(str(int(pedestrian)))

    if state == CLOSED:
        expected_states.append(CLOSED)
        combined_trace.append(f"{CLOSED}_{int(pedestrian)}")
        counter += 1
        if counter == OPENING_TIME:
            state = OPEN
            counter = 0
    elif state == OPEN:
        expected_states.append(OPEN)
        combined_trace.append(f"{OPEN}_{int(pedestrian)}")
        counter += 1
        if counter == CLOSING_TIME or pedestrian:
            state = CLOSING
            counter = 0
    elif state == CLOSING:
        expected_states.append(CLOSING)
        combined_trace.append(f"{CLOSING}_{int(pedestrian)}")
        counter += 1
        if counter == CLOSING_BLINK:
            state = CLOSED
            counter = 0
    else:
        expected_states.append(CLOSED)
        combined_trace.append(f"{CLOSED}_{int(pedestrian)}")
        state = CLOSED
        counter = 0

# Escrita dos arquivos
with open("semaphore_expected.txt", "w") as f:
    f.write("\n".join(expected_states))

with open("pedestrian_input.txt", "w") as f:
    f.write("\n".join(pedestrian_inputs))

with open("combined_trace.txt", "w") as f:
    f.write("\n".join(combined_trace))

print("Arquivos gerados:")
print("- semaphore_expected.txt")
print("- pedestrian_input.txt")
print("- combined_trace.txt")
