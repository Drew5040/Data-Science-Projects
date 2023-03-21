import matplotlib.pyplot as plt
import yfinance as yf
import pandas as pd

# Read in data from yfinance
coindata = yf.Ticker("LINK-USD").history(period="max").reset_index()[["Date", "Open"]]

# convert date to pandas datetime
coindata["Date"] = pd.to_datetime(coindata["Date"])

# create a column of values shifted 90 days in past
coindata["90day"] = coindata["Open"].shift(-90)/coindata["Open"]

# create a column of values shifted 180 days in the past
coindata["180day"] = coindata["Open"].shift(-180)/coindata["Open"]

# create a column of values shifted 360 days in the past
coindata["360day"] = coindata["Open"].shift(-360)/coindata["Open"]

# choose style
plt.style.use("dark_background")

# plot the columns
plt.plot(coindata["Date"], coindata["90day"], label="90day", color="cornflowerblue", linewidth=.8)
plt.plot(coindata["Date"], coindata["180day"], label="180day", color="goldenrod", linewidth=.8)
plt.plot(coindata["Date"], coindata["360day"], label="360day", color="forestgreen", linewidth=.8)

# plot title & legend
plt.title("LINK ROI by holding period", size=20)
plt.legend()

# save figure
plt.savefig("LINK-90-180-360_ROI")

# show the figure
plt.show()




