using DataFrames

df = DataFrame(A=[1,2], B=["hello","world"])

df.c = df.A .^ 2
