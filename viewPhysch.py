import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

df = pd.read_csv("particles.csv")

frame = 0
df_frame = df[df['frame'] == frame]

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter(df_frame['x'], df_frame['y'], df_frame['z'])
plt.show()
