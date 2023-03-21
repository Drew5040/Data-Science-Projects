#####################################################################################
# Using Modern Portfolio Theory and Monte Carlo Simulation for Portfolio Optimization
#####################################################################################

import plotly.express as px
import pandas as pd
import yfinance as yf
import numpy as np


# Pulls in crypto price history
def api_call(string):
    data = yf.Ticker(string + '-USD').history(period='max', interval='1wk').reset_index()[['Date', 'Open']]
    data = data.rename(columns={'Open': string})
    return data


# Pull in the time series data for each coin we want in our portfolio
btc = api_call('BTC')
link = api_call('LINK')
eth = api_call('ETH')


# Merge all data into 1 larger data frame
final_df = pd.merge(btc, link, on='Date', how='inner')
final_df = pd.merge(final_df, eth, on='Date', how='inner')

# reset the index column for time series data
final_df = final_df.set_index('Date')

# Calculates the chosen period return for each coin in dataframe
df_returns = final_df.pct_change()

# Historical average of each crypto return in dataframe
# Needed for calculating each portfolio return
df_avg_returns = df_returns.mean()

# Calculate the historical covariance matrix of returns that includes each crypto in dataframe
df_cov_matrix = df_returns.cov()

# Column headers
crypto = ['BTC', 'LINK', 'ETH']

num_simulations = 100000

# Need a container to store simulation results in
# Create a numpy array of zeroes using a tuple
simulation_results = np.zeros((4 + len(crypto) - 1, num_simulations))


# SIMULATE PORTFOLIOS
# Each iteration of the loop is going to generate 1 simulated portfolio
# which will then be stored in the zeros array

for i in range(num_simulations):

    # create a weights array
    # to hold 'n' random numbers depending on how many crytos we want in our final portfolio
    # They will be the random weightings of BTC and LINK and ETH
    random_weights = np.array(np.random.random(3))

    # divide each value in the array by the sum
    # To get the percentage weighting of each asset in the portfolio
    portfolio_random_weights = random_weights / np.sum(random_weights)

    # calculate each portfolios returns
    portfolio_returns = np.sum(df_avg_returns * portfolio_random_weights)

    # calculate the portfolio standard deviation using dot-product
    portfolio_standard_deviation = np.sqrt(np.dot(portfolio_random_weights.T, np.dot(df_cov_matrix, portfolio_random_weights)))

    # Populate our simulation results by indexing into our zeroes array
    simulation_results[0, i] = portfolio_returns
    simulation_results[1, i] = portfolio_standard_deviation

    # sharp ratio
    simulation_results[2, i] = simulation_results[0, i] / simulation_results[1, i]

    # To fill the remaining values use a for loop to iterate through
    # weights variable.
    for j in range(len(portfolio_random_weights)):
        simulation_results[j + 3, i] = portfolio_random_weights[j]
      

# Turn the transposed NumPy array into a pandas dataframe to begin visualizing
result_plot = pd.DataFrame(simulation_results.T, columns=["AVG-RET", "STDV", "SHARPE", crypto[0], crypto[1], crypto[2]])

# Turn the dataframe into a plotly express scatterplot. Create the hover-data
scatter_plot = px.scatter(result_plot, x='STDV', y='AVG-RET', color='SHARPE', template="plotly_dark",
                 hover_data=[crypto[0], crypto[1], crypto[2]])


# Update the X and Y Axis on scatterplot
scatter_plot.update_xaxes(title_text="Volatility", title_font_size=20)
scatter_plot.update_yaxes(title_text="Average Returns", title_font_size=20)

# Display the results   
scatter_plot.show()
