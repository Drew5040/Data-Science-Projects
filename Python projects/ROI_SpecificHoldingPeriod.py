import matplotlib.pyplot as plt
import yfinance as yf
import pandas as pd

coindata = yf.Ticker("LINK-USD").history(period="max").reset_index()[["Date", "Open"]]
coindata["Date"] = pd.to_datetime(coindata["Date"])
coindata["90day"] = coindata["Open"].shift(-90)/coindata["Open"]
coindata["180day"] = coindata["Open"].shift(-180)/coindata["Open"]
coindata["360day"] = coindata["Open"].shift(-360)/coindata["Open"]
print(coindata)

plt.style.use("dark_background")
plt.plot(coindata["Date"], coindata["90day"], label="90day", color="cornflowerblue", linewidth=.8)
plt.plot(coindata["Date"], coindata["180day"], label="180day", color="goldenrod", linewidth=.8)
plt.plot(coindata["Date"], coindata["360day"], label="360day", color="forestgreen", linewidth=.8)

#plt.title("LINK ROI by holding period", size=20)
plt.legend()
plt.savefig("LINK-90-180-360_ROI")
plt.show()


