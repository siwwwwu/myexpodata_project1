filename = 'new_data.txt'
new_data = read.table(file = filename, header = TRUE)

d =as.Date(t(as.vector(new_data['Date'])), "%d/%m/%Y") 
t = t(as.vector(new_data['Time']))
x<- paste(d,t)

DateTime = data.frame(t(strptime(x, "%Y-%m-%d %H:%M:%S")))
tb = cbind(new_data, DateTime)
colnames(tb)[length(colnames(tb))] = "DateTime"

png(filename = 'plot2.png')
plot(tb$DateTime, tb$Global_active_power,type='l', ylab = "Global Active Power(kilowatts)",xlab = "")
dev.off()

