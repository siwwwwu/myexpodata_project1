filename = 'new_data.txt'
new_data = read.table(file = filename, header = TRUE)

d =as.Date(t(as.vector(new_data['Date'])), "%d/%m/%Y") 
t = t(as.vector(new_data['Time']))
x<- paste(d,t)

DateTime = data.frame(t(strptime(x, "%Y-%m-%d %H:%M:%S")))
tb = cbind(new_data, DateTime)
colnames(tb)[length(colnames(tb))] = "DateTime"

png(filename = 'plot4.png')

par(mfrow = c(2,2))
plot(tb$DateTime, tb$Global_active_power,type='l', ylab = "Global Active Power",xlab = "")

with(tb,plot(DateTime, Voltage, type="l", ylab = "Voltage"))

with(tb,plot(DateTime,Sub_metering_1, type = "l", col = "black",ylab = "Energy Sub Metering"))
with(tb,lines(DateTime,Sub_metering_2, type = "l", col = "red"))
with(tb,lines(DateTime,Sub_metering_3, type = "l", col = "blue"))
legend("topright",lty=c(1,1,1), col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),cex=.75)

with(tb, plot(DateTime, Global_reactive_power, type = "l",ylab = "Global Reactive Power" ))

dev.off()