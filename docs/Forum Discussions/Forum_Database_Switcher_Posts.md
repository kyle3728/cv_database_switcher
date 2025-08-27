# CV 12 Database Switcher

*Cabinet Vision Forum Discussion - Total Posts: 25*

---

**Tristan R** - Feb 21, 2020 3:30 AM

Anyone been able to do this from V10 onwards? Is it just not worth it or is there a better way to manage/work with multiple databases. If you say it can't be done I beg to differ ;)

---

**John "Zeke" Charles** - Feb 29, 2020 4:28 AM

I haven't used a switch utility but I have successfully run multiple database directories, with SQL Data Source, in CV9 and C11 on a windows 7 computer. It works wonderfully for me, I simply rename the database directories when I need to switch, having only one 'Database' folder that is, and when I click update version there are no issues. I do not have to stop the SQL server or anything. CV12 is not installed on this computer... I'd love to know why this works on my current computer but not on a new computer that I just tried to set up with this same method. I attempted this in CV11 only with no luck, it causes SQL errors and the only resolution to fix the error(s), that I've found, was to reinstall CV... This computer does have CV12 installed also, CV11 was installed first & CV9 was never installed... Lastly, I have had this working on another Windows 10 Home OS, with CV9 & CV11, as well. I sure do wish it is possible to run multiple database files like I've been doing for years in CV11... Do you have any more to add or are you seeking the same resolve?

---

**Tristan R** - Feb 29, 2020 5:13 AM

Nice if I understand you correctly that's exactly how I do it. I have a few batch files, one for each database/system configuration that I run to rename database directories and files. I can completely switch between multiple systems as if I were sitting on a completely different computer. I will integrate switching system parameters as well, I believe it's just writing to the registry. I'm running CV12 and it's pretty much flawless, what errors are you getting? I don't see any reason why it wouldn't work in CV11. I haven't figured out how to switch the default settings properly, I thought all that info was in default.dat but it doesn't appear to work as I get a couple errors when opening after switching about the default material schedules missing.

---

**John "Zeke" Charles** - Feb 29, 2020 5:32 AM

Yes, we are doing it the same way though I manually rename and do not set up a batch file. After I first make a copy of the default database directory and switch that one to my 'active' database I click update version and the first error message is Microsoft OLE DB Provider for SQL Server BackupSQL Error #-2147217900 - Database 'CxMaterials_11' cannot be opened due to inaccessible files or insufficient memory or disk space. See the SQL Server error log for details. This happens even if I simply make a copy of the database folder and leave all the default data in the duplicate. As mentioned, it has worked perfectly on my old computer and my backup laptop with windows 10... I cannot seem to get it to work on the new computer though. Any ideas? Did you also have any previous version of CV and/or MS SQL Server on your computer?

---

**Tristan R** - Feb 29, 2020 5:44 AM

Yea I did that at first, but found it tedious as I can switch pretty often sometimes. I have CV10, 11 and 12 installed and I recently upgraded SQL to 2012. When you copy the database does it ask you for administrative permission to do so? I was getting an error as well but it had to do with permissions being removed on the actual database files when copied. I had to temporarily modify the permissions on the database files that were copied, then do a backup/restore of them to have everything set properly and give SQLServer permission again.

---

**John "Zeke" Charles** - Feb 29, 2020 6:26 AM

It did ask for administrative permission when copying. My user account controls are disabled on my Windows 7 computer, maybe that's the reason why it didn't work on the new computer(???) that has them enabled...

---

**Tristan R** - Feb 29, 2020 8:16 AM

Try comparing the permissions on the construction and materials sql database files for the copy and original. You should find that SQLServer has been removed on the copy, if this is the case, try manually adding 'everyone' for the copy and allow full control. Do this for each database file including the .sql and .log files as well, then try opening CV. I wouldn't recommend leaving them this way which is why I then do a backup/restore so it sets the permissions properly and you are left with multiple database files with proper permissions that you can just change the names to switch between databases. It requires a little setup to add new databases but once their added you can always restore them (if their someone else's backup) without having to go through this process again.

---

**John "Zeke" Charles** - Mar 2, 2020 1:48 AM

Thanks, I will give this a try soon and report back if all goes well.

---

**Tristan R** - Mar 9, 2020 10:51 AM

Just incorporated switching of system parameters, if I could only figure out the default settings so I don't get "material schedule missing" error messages every time I switch. I though it was the default.dat file but doesn't appear to be. If some CV guru knows I'd really appreciate being pointed in the right direction.

---

**John "Zeke" Charles** - Mar 11, 2020 12:32 PM

You are looking for the SysParams.reg file that can be created with the Backup Utility, it is created when you select "System Parameters"... I would be careful with this though, take a look at that file in notepad++ and you'll see why I say that. Default.dat only contains layer settings.

---

**Tristan R** - Mar 16, 2020 9:26 PM

Yes, thank you that's exactly what I was looking for!

---

**Tristan R** - Mar 26, 2020 6:51 AM

```batch
set NewDatabase=Streamlined
set /p CurrentDatabase=<"C:/Cabinet Vision/Solid_12/Database/Database_Name.txt"

echo y|reg export "HKEY_CURRENT_USER\Software\Cabinet Vision\Solid_12\Settings" "C:\Cabinet Vision\Solid_12\Database\DefaultSettings.reg"
ren "C:\Cabinet Vision\Solid_12\Database" "Database - %CurrentDatabase%"
ren "C:\Cabinet Vision\NcCenter_12\Database" "Database - %CurrentDatabase%"
ren "C:\Cabinet Vision\Solid_12\Default.dat" "Default - %CurrentDatabase%.dat"
ren "C:\Cabinet Vision\Solid_12\DefaultCLST.dat" "DefaultCLST - %CurrentDatabase%.dat"

ren "C:\Cabinet Vision\Solid_12\Database - %NewDatabase%" "Database"
ren "C:\Cabinet Vision\NcCenter_12\Database - %NewDatabase%" "Database"
ren "C:\Cabinet Vision\Solid_12\Default - %NewDatabase%.dat" "Default.dat"
ren "C:\Cabinet Vision\Solid_12\DefaultCLST - %NewDatabase%.dat" "DefaultCLST.dat"
regedit.exe /S "C:\Cabinet Vision\Solid_12\Database\DefaultSettings.reg"

start /d "C:/Cabinet Vision/Solid_12" CVUpdateVersion.exe
```

---

**Mitch Fairbanks** - Mar 2, 2021 11:13 PM

Do you set this as a .Bat file or .Reg file? Thanks in advance

---

**Tristan R** - Mar 3, 2021 9:34 PM

It's a batch file, and has since been revised to receive user input for which database/configuration to use and also only switch if CV is not running. It's really just a template for the procedure, you'll need to be familiar with batch scripting since you'd have to modify a few things to make it work for you. Just make sure you're CV is properly backed up if you're going to experiment with this.

---

**Robert Nagy** - Apr 18, 2023 12:53 PM

Hi Tristan, This sounds like a good idea. I am not familiar with bat files, could yo possibly help me set this up, please? Thanks. Much appreciated.

---

**Tristan R** - Apr 21, 2023 8:09 PM

You could probably learn a ton more from google on batch files than I could get into here on the forum, if you're not comfortable making/editing them then you could follow the steps above and manually change between databases. All you need to do is go to your CV_#### folder, copy the "Database" folder and rename it to something like "Database - Setup 2". Then go into it and set all permissions on the SQL database files so the "everyone" group has full control (this is very important). You can then just change the names of the two (or however many you have) database folders, keeping track of which one is which CV database/system, and restore a full backup of the system you want assigned to it. When you open CV, it will always use the one called "Database" and ignore anything else like "Database - Setup 2". After all is said and done you'd have something like this: Probably goes without saying but you'd likely replace "Setup #" with something more descriptive of the database (like a company name, or what you're associating that database with).

---

**John "Zeke" Charles** - Apr 22, 2023 11:16 PM

I've been meaning to set this up for a very long time... One question I've been meaning to ask is, do you create an independent batch file for each "Database -Setup"?

---

**John "Zeke" Charles** - Apr 27, 2023 2:07 AM

Sounds like a fun project. I would enjoy something like that. Others might like this, it might even be a marketable item but even more so if it were supported, included upgrades, etc.

---

**Jim Underwood** - Apr 27, 2023 12:07 PM

Did you ever see Jonah Coleman's database switcher app?

---

**Robert Nagy** - May 4, 2023 6:53 AM

Hi Jim, no I haven't seen it but would be happy to see how he overcomes this. Thanks

---

**Jim Underwood** - May 4, 2023 12:12 PM

The file was floating around here at some point. I used it once or twice, but I nearly screwed up my entire network database, so I didn't mess with it anymore. Not sure if it would work now either. I'm sure he's not supporting it anymore.

---

**Cory Mfg** - May 4, 2023 2:26 PM

I think Jonah indicated that it is not compatible after v9.

---

**Jim Underwood** - May 4, 2023 3:34 PM

Thanks. Figured that must be the case.

---

**Cory Mfg** - Apr 8, 2023 8:47 PM

Tristan, have you updated this for 2022? I'd be very appreciative to see the bat file for 2022.Never mind, I see that I just need to change paths and generate a reg file with the stuff that I want.

---

**Tristan R** - Apr 10, 2023 11:58 PM

Beat me to it but yea, that's pretty much it.

---

