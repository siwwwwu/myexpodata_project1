filename = "household_power_consumption.txt"
data = read.table(file = filename, header = TRUE, sep = ";", na.strings = "?")
data['Date'] = as.character.Date(data['Date'])
new_data = data[(data['Date']=='1/2/2007' |data['Date']=='2/2/2007'),]

write.table(new_data,"new_data.txt", row.names = FALSE)
d =as.Date(t(as.vector(new_data['Date'])), "%d/%m/%Y") 
t = t(as.vector(new_data['Time']))
x<- paste(d,t)

DateTime = data.frame(t(strptime(x, "%Y-%m-%d %H:%M:%S")))

tb <- cbind(new_data,DateTime)
colnames(tb)[length(colnames(tb))] = "Ddata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAMElEQVR42mNgIAXY2Nj8x8cHC8AwMl9XVxe3QqwKcJmIVwFWhehW4LQSXQCnm3ABAHD6MDrmRgfrAAAAAElFTkSuQmCCateTime"

library(datasets)
png(filename = 'plot1.png')
hist(tb$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)",yaxt='n')
axis(side=2, at= seq(0,1200,200), labels = seq(0,1200,by=200) )
dev.off()
