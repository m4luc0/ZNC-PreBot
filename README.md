# PreBot module for ZNC
This is a PreBot module for the [ZNC IRC Bouncer](http://znc.in/) written in Perl.

Setting up a custom IRC-Bot could be pretty annoying, so why not just use your bnc? ZNC offers the best way to implement simple Perl modules, so I decided to set up my PreBot as a ZNC module. It's probably the simplest way to run a PreBot script like this. Just grab the module, edit the MySQL DB settings an start filling your own PreDB.

##How does it work?
The module tracks all your channels for new releases and adds them into your PreDB. The module uses regex to recognize an incoming *PRE/NUKE/UNNUKE/DELPRE/UNDELPRE*. The regex I'm using will work on many prechans but not on all. You'll have to test it by yourself. If you have a regex that matches all prechans in the world let me know and I'll update the code. If you don't know anything about regex, take a look at this [perl regex overview](http://www.comp.leeds.ac.uk/Perl/matching.html).

A good place for testing a regex is https://www.debuggex.com/. Copy the default regex to the upper field and copy a normal *PRE* from your prechan to the bottom field. If you don't have the section + release as a match you'll have to customize it.
```
PRE regex: ^\W*\w+\W+(\w+-?\w+)\W+(\w.+?)\W*$
NUKE regex: ^\W*\w+\W*(\w.+?)\W*(\w[\w|\.|-]*)\W*$
INFO regex: ^\W*\w+\W*(\w.+?)\W*(\d+\s\w+?)\W*(\d.+?)\W*$

Matches all kind of different pres, just assuming a common PRE/NUKE/INFO order:
PRE SECTION RELEASE
NUKE RELEASE REASON
INFO RELEASE FILES SIZE

Examples:
PRE XXX This.is.a.super.hot.release-H0tSHiT
PRE - XXX - This.is.a.super.hot.release-H0tSHiT
PRE: [XXX] This.is.a.super.hot.release-H0tSHiT
[PRE] [XXX] [This.is.a.super.hot.release-H0tSHiT]
[PRE] - [XXX] - [This.is.a.super.hot.release-H0tSHiT]

NUKE This.is.a.super.hot.release-H0tSHiT nuke.wars.reason
NUKE - This.is.a.super.hot.release-H0tSHiT - nuke.wars.reason
NUKE: This.is.a.super.hot.release-H0tSHiT [nuke.wars.reason]
[NUKE] [This.is.a.super.hot.release-H0tSHiT] [nuke.wars.reason]

etc etc etc ...
```

It's pretty simple to use and easy to understand.
I've tried to comment everything that could be important for a better code understanding,
so even perl beginners should be able to use and modify it for custom purposes.

## Prerequisites

* ZNC installed and running. Don't know how to install it? Take a look at the [official guide](http://wiki.znc.in/Installation).
* MySQL server running. In case you're using another DB type you'll have to rewrite some code lines.
* Knowledge about starting Perl modules in ZNC. Don't know how to do that? Take a look at the ZNC [Modperl wiki page](http://wiki.znc.in/Modperl).
* Last but not least: a hungry PreDB. I prepared some configuration variables. It will allow you to use your own db structure and column names. Your PreDB structure **could** look like this:

```sql
CREATE TABLE IF NOT EXISTS `releases` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pretime` int(11) NOT NULL,
  `release` varchar(200) NOT NULL,
  `section` varchar(20) NOT NULL,
  `files` int(5) NOT NULL DEFAULT '0',
  `size` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` int(1) NOT NULL DEFAULT '0',
  `reason` varchar(255) NOT NULL DEFAULT '',
  `group` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `release` (`release`),
  KEY `grp` (`group`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
```

## Installation
Make sure that you've configured ZNC with the **--enable-perl** flag. Don't know what I'm talking about? Take a look at the ZNC [Modperl wiki page](http://wiki.znc.in/Modperl). Furthermore I assume that your MySQL server is running with a prepared db, so you just need to install some Perl modules. The best way to install Perl modules is via [cpanm](https://metacpan.org/pod/App::cpanminus). To install the required packages just type the following commands into your shell:

**1.** Install _cpanm_ (if you're not already using it)
```powershell
curl -L https://cpanmin.us | perl - --sudo App::cpanminus
```

**2.** Install the required Perl modules
```powershell
cpanm POE::Component::IRC
cpanm experimental
cpanm DBI
cpanm DBD::mysql
```

## Usage

**1.** Download the *PreBot.pm* file to the ZNC modules directory
```powershell
cd ~/.znc/modules
wget https://raw.githubusercontent.com/m4luc0/ZNC-PreBot/master/PreBot.pm
```
**2.** Open the file with your favorite text editor and change the MySQL DB settings.

**3.** Start the module via IRC or webpanel. To start via IRC type in the following code into your client:
```
/msg *status loadmod PreBot
```

## Support
If you need support on any issue about ZNC just say hello at the **#znc** channel on [freenode](https://webchat.freenode.net/). I'll be there too, you can drop me a line if you need specific help for this module.

## Any suggestions or bugs?
Have a bug or a feature request? Or you know how I can improve the code quality?
[Please open a new issue](https://github.com/m4luc0/ZNC-PreBot/issues).  
__Before opening any issue, please search for existing issues.__
