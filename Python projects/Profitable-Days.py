import plotly.graph_objects as go
import numpy as np
import pandas as pd

# Read in data from CSv
from matplotlib import pyplot as plt

df = pd.read_csv("../Log.Rainbow.Regression/LINK-USD.csv")

# Convert Date-time to pandas readable format
df["Date"] = pd.to_datetime(df["Date"])

# Grab latest price
latest_price = df["Value"].iloc[1517]

# Creates a profit column in our dataframe
df["Profit"] = df["Value"]

# Find where BTC was not profitable and remove the value from profit column "inplace"ensures changes to this dataframe
df["Profit"].where(df["Value"] < latest_price, None, inplace=True)

# PLOT

# Create Chart
fig = go.Figure()

# Trace is any sort of line or scatter graph (Line graphs are a subset of scatter graphs in plotly
# Create X any Y axis
# First Trace draws a red line graph on which we then will draw a green graph over top of red graph

fig.add_trace(go.Scatter(
    x=df["Date"],
    y=df["Value"],
    name="Loss",
    line=dict(color="red")
))

# Since this Trace is lower down in the program it will be drawn on top of the first trace
fig.add_trace(go.Scatter(
    x=df["Date"],
    y=df["Profit"],
    name="Profit",
    line=dict(color="green")
))

# Add dynamic annotation that changes when data gets updated
# Show arrow can be used to point to a specific location on graph
# xref and yref allows us to locate the annotation as a percentage of the graph

total_days = len(df)
total_profitable_days = len(df[df["Profit"] < latest_price])
percent_profitable = round(total_profitable_days / total_days * 100, 2)

fig.add_annotation(text=f"Total Days:  {total_days}",
                   xref='paper', yref="paper",
                   x=0.05, y=0.9, showarrow=False,
                   font=dict(size=20))

fig.add_annotation(text=f"Total Profitable Days:  {total_profitable_days}",
                   xref='paper', yref="paper",
                   x=0.05, y=0.80, showarrow=False,
                   font=dict(size=20))

fig.add_annotation(text=f"Percent Profitable:  {percent_profitable}",
                   xref='paper', yref="paper",
                   x=0.05, y=0.70, showarrow=False,
                   font=dict(size=20))

# Make chart LOG Scale
# Get rid of grid lines
# Change background color

fig.update_yaxes(type="log", showgrid=False)
fig.update_xaxes(showgrid=False)
fig.update_layout(template="plotly_dark")

plt.savefig("LINK-PROFITABLE-DAYS.png", dpi=300)
fig.show()


