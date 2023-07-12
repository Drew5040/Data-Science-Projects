import plotly.graph_objects as go
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

# Read in data from CSV
df = pd.read_csv("../Log.Rainbow.Regression/LINK-USD.csv")

# Convert Date-time to pandas readable format
df["Date"] = pd.to_datetime(df["Date"])

# Grab latest price
latest_price = df["Value"].iloc[1957]

# Create profit column in our dataframe
df["Profit"] = df["Value"]

# Find where BTC was not profitable and remove the values from profit column
df["Profit"].where(df["Value"] < latest_price, None, inplace=True)


# Create Chart
fig = go.Figure()


# Add first trace
fig.add_trace(go.Scatter(
    x=df["Date"],
    y=df["Value"],
    name="Loss",
    line=dict(color="red")
))

# Add top trace
fig.add_trace(go.Scatter(
    x=df["Date"],
    y=df["Profit"],
    name="Profit",
    line=dict(color="green")
))

# Create variables for the dynamic annotation
total_days = len(df)
total_profitable_days = len(df[df["Profit"] < latest_price])
percent_profitable = round(total_profitable_days / total_days * 100, 2)

# Add total days annotation
fig.add_annotation(text=f"Total Days:  {total_days}",
                   xref='paper', yref="paper",
                   x=0.05, y=0.9, showarrow=False,
                   font=dict(size=20))

# Add total profitable days annotation
fig.add_annotation(text=f"Total Profitable Days:  {total_profitable_days}",
                   xref='paper', yref="paper",
                   x=0.05, y=0.80, showarrow=False,
                   font=dict(size=20))

# Add percentage of days that were profitable annotation
fig.add_annotation(text=f"Percent Profitable:  {percent_profitable}",
                   xref='paper', yref="paper",
                   x=0.05, y=0.70, showarrow=False,
                   font=dict(size=20))


# Make chart LOG Scale
fig.update_yaxes(type="log", showgrid=False)

# Get rid of grid lines
fig.update_xaxes(showgrid=False)

# Change background color
fig.update_layout(template="plotly_dark")

# Save figure
plt.savefig("LINK-PROFITABLE-DAYS.png", dpi=300)

# Show figure
fig.show()


