import numpy as np

# generate a matrix with 7 rows and 10 columns, each value between 0.4-1.0 precision 2
matrix = np.random.uniform(1.0, 20.0, (7, 7))
matrix = np.round(matrix, 2)
# print weight with comma separate
for row in matrix:
    print('['+', '.join(map(str, row))+'],')