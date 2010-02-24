#reefree.R
#Xavier de Blas xaviblas@gmail.com
#version: 0.1

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.


reefAllDays <- read.csv2('reef.csv',na.strings = "", sep=";", dec = ",", header=T)
reefAllDays$datesOK=as.Date(reefAllDays$Dates,format='%d/%m/%Y')
reef <- reefAllDays

CaOK=c(400, 500) #Borneman
#CaOK=c(350, 450) #Sprung
CaIdeal=c(450,499) #Borneman

KhOK=c(7, 12) #Borneman
#KhOK=c(7, 10) #Sprung

MgOK=c(1200, 1350) #Calfo, p129: roughtly three times the proper level of calcium
NO3OK=c(0, 10) #Borneman
PO4OK=c(0, 0.1)

aq.min <- function(values, minRecommended) {
	minFound = min(values,na.rm=T)
	ret = minRecommended
	if(minFound < minRecommended) ret = minFound
	return(ret)
}

aq.max <- function(values, maxRecommended) {
	maxFound = max(values,na.rm=T)
	ret = maxRecommended
	if(maxFound > maxRecommended) ret = maxFound
	return(ret)
}

aq.lines <- function(range,type) {
	if(type=="ok")
		l = 1
	else #type == "ideal"
		l = 2
		
	abline(h=range[1],col='green', lty=l)
	abline(h=range[2],col='green', lty=l)
}

aq.water <- function(type) {
	if(type=='p') {
		plot(reef$Water~reef$datesOK, main="", type='h',  
			ylim=c(0,3*max(reef$Water,na.rm=T)), col='blue', axes=F, xlab='', ylab='')
		axis(2,col='blue',pos=reef$datesOK[1],at=seq(from=0, to=max(reef$Water,na.rm=T), by=20))
	}
	else #currently unused
		plot(reef$Water~reef$datesOK, main="Water", type='h', ylim=c(0,max(reef$Water,na.rm=T)), 
			col='blue', axes=T, xlab='', ylab='litres')
}

#paint one param
pinta <- function(x.val, y.val, y.range, title) {
	plot(y.val~x.val, main=title, type='p', axes=T, xlab='', ylab='ml', 
		ylim=c(aq.min(y.val,y.range[1]), aq.max(y.val,y.range[2])))
	aq.lines(y.range,"ok")
	if(title=="Ca")
		aq.lines(CaIdeal,"ideal")
	par(new=T)
	aq.water('p')
}

#paint one param, and addition of that param
pinta2 <- function(x.val, y.val, y.range, y2.val, title) {
	pinta(x.val, y.val, y.range, title)
	par(new=T)
	plot(y2.val~x.val, main="", type='s', axes=F, xlab='', ylab='', col='red', ylim=c(0,3*max(y2.val,na.rm=T)))
	#axis(4, col='red', at=c(0,max(y2.val,na.rm=T)))
	axis(4, col='red', at=seq(from=0, to=max(y2.val,na.rm=T), by=10))
	par(new=F)
} 

aq.export <- function(filename, aq.size) {
	png(filename = filename, width = aq.size[1], height=aq.size[2], units = 'px'
	, pointsize = 12, bg = 'white', res = NA)
}

#---------------- graphs of params ---------

aq.ca <- function() { pinta2(reef$datesOK, reef$Ca, CaOK, reef$Ca.d, "Ca") }
aq.kh <- function() { pinta2(reef$datesOK, reef$Kh, KhOK, reef$Kh.d, "Kh") }
aq.mg <- function() { pinta2(reef$datesOK, reef$Mg, MgOK, reef$Mg.d, "Mg") }
aq.no3 <- function() { pinta(reef$datesOK, reef$NO3, NO3OK, "NO3") }
aq.po4 <- function() { pinta(reef$datesOK, reef$PO4, PO4OK, "PO4") }

#---------------- user calls from R ---------------

aq.graph <- function(param) {
	if(param=="ca" || param=="Ca") { 
		aq.export("Ca.png", c(500,500))
		aq.ca() 
		dev.off()
	}
	else if(param=="kh" || param=="Kh") {
		aq.export("Kh.png", c(500,500))
		aq.kh() 
		dev.off()
	}
	else if(param=="mg" || param=="Mg") {
		aq.export("Mg.png", c(500,500))
		aq.mg() 
		dev.off()
	}
	else if(param=="no3" || param=="NO3") {
		aq.export("NO3.png", c(500,500))
		aq.no3() 
		dev.off()
	}
	else if(param=="po4" || param=="PO4") {
		aq.export("PO4.png", c(500,500))
		aq.po4() 
		dev.off()
	}
}

aq.ca.kh.mg <- function() {
	aq.export("Ca-Kh-Mg.png", c(900,700))
	par(mfrow=c(3,1))
	aq.ca()
	aq.kh()
	aq.mg()
	par(mfrow=c(1,1))
	dev.off()
}

aq.all <- function(option) {
	aq.export("all.png", c(1024,768))
	if(option==1)
		par(mfrow=c(5,1), mar=c(5,2,2,2))
	else
		par(mfcol=c(3,2))
	aq.ca()
	aq.kh()
	aq.mg()
	aq.no3()
	aq.po4()
	#aq.water('h')
	par(mfrow=c(1,1), mar=c(5,4,4,2))
	dev.off()
}

#aq.dispersion(reef$NO3,reef$PO4)
aq.dispersion <- function(a,b,aName,bName) {
	aq.export("NO3-PO4.png", c(900,700))
	plot(b~a, xlab=aName, ylab=bName)
	abline(lm(b ~ a),col='red')
	text(min(a,na.rm=T),max(b,na.rm=T),paste("R²=",round(cor(a,b,use="complete")^2,3)),cex=1,adj=c(0,0))
	dev.off()
}

#el <<- es per a que faci assignement a la variable global reef i no a la local que es crea en fer un assignment normal
#R-intro.pdf pag 46-47
aq.Days <- function(n) {
	if(n==-1) reef <<- reefAllDays
	else reef<<-subset(reefAllDays, Sys.Date()-reefAllDays$datesOK <= n)
}

returnMessage=""

aq.waterChanges <- function() {
	changed = sum(reef$Water,na.rm=T)
	returnMessage <<- paste(changed, " (", 100 * sum(reef$Water,na.rm=T) /300, "%)", sep="")
}

aq.chemist <- function() {
	returnMessage <<- c(
		paste("Ca=(", CaOK[1], "-", CaOK[2], ")", sep=""), 
		paste("Kh=(", KhOK[1], "-", KhOK[2], ")", sep=""), 
		paste("Mg=(", MgOK[1], "-", MgOK[2], ")", sep=""), 
		paste("NO3=(", NO3OK[1], "-", NO3OK[2], ")", sep=""), 
		paste("PO4=(", PO4OK[1], "-", PO4OK[2], ")", sep="") 
	)
}

aq.help <- function() {
	returnMessage <<- c(
	"REEFREE help:",
	"all: plot all params",
	"Ca.Kh.Mg: plot Ca, Kh and Mg",
	"Ca: plot Ca",
	"Kh | Mg | NO3 | PO4: plot Kh or Mg or NO3 or PO4", 
	"chemist: show recommended chemist ranges",
	"water: display water changes",
	"NO3-PO4: dispersion graph of this params",
	"",
	"examples:",
	"'Rscript reefree.R Ca': plot Ca for all days",
	"'Rscript reefree.R Ca.Kh.Mg': plot Ca, Kh and Mg in a graph for all days",
	"'Rscript reefree.R all 30': plot all params for last 30 days",
	"'Rscript reefree.R all2 90': plot all params (different display) for last 90 days",
	"'Rscript reefree.R water 60': display water changes for last 60 days",
	"",
	"Suggested reading: http://reefkeeping.com/issues/2004-05/rhf/"
	)
}

#---------------------- user calls from command line ------------------

args <- commandArgs(TRUE)
paramsOK = FALSE
printMessage = FALSE

if(length(args) == 2) 
	aq.Days(as.numeric(args[2]))
if(length(args) == 1 || length(args) == 2) { 
	args=args[1]
	if(args == "all" || args == "ALL" || args == "all1" || args == "ALL1") {
		aq.all(1) 
		paramsOK = TRUE
	}
	if(args == "all2" || args == "ALL2") {
		aq.all(2) 
		paramsOK = TRUE
	}
	if(args == "ca.kh.mg" || args == "Ca.Kh.Mg") {
		aq.ca.kh.mg()
		paramsOK = TRUE
	}
	if(args == "Ca" || args == "ca" || args == "Kh" || args == "kh" || args == "Mg" || args == "mg" ||
		args == "NO3" || args == "no3" || args == "PO4" || args == "po4") {
		aq.graph(args)
		paramsOK = TRUE
	}
	if(args == "NO3-PO4" || args == "no3-po4") { 
		aq.dispersion(reef$NO3,reef$PO4,"NO3","PO4")
		paramsOK = TRUE
	}
	if(args == "chemist") { 
		aq.chemist()
		paramsOK = TRUE
		printMessage = TRUE
	}
	if(args == "water") { 
		aq.waterChanges()
		paramsOK = TRUE
		printMessage = TRUE
	}
}
if(length(args) <1 || length(args) >2 || paramsOK == FALSE) {
	aq.help() 
	printMessage = TRUE
}

if(printMessage) returnMessage
