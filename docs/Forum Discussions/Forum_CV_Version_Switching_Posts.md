# With CV having new build every 3 months to be able to have all installs in different folder locations

*Cabinet Vision Forum Discussion - August 7, 2023*

---

**Kevin_ValleyCabinet** - Aug 7, 2023 12:03 PM

Has any one tried to have the 23.1 and 23.2 install but in different file location?

To be able to have both programs installed for use and testing. Then if 23.2 is not working for you, you can go back to 23.1 without having to do all the hoop jumping to go back to 23.1.

This way also the jobs in 23.2 you can still muddle through if you roll back to 23.1 

I'm thinking about trying this, to have both install on my PC. Then with 23.3 when that comes out the same...

I see a lot of benefits if CV would just install a new program instead of over the top.

---

**Toby Richards** - Aug 7, 2023 1:21 PM

Let me know how you get on. Im still on 23.1 because I am happy with the program and do not think the features are worth me upgrade all our design team. I really want to be able to run the software without having to say goodbye to my current one.

I guess you could run the software in a virtual machine...

---

**Kevin_ValleyCabinet** - Aug 7, 2023 3:07 PM

Ill test it out this week

---

**Kevin_ValleyCabinet** - Sep 11, 2023 10:14 AM

So yes my test does work

Rename the current file CV 2023 to CV 2023.1

Then CV will install CV2023.2 as CV 2023 folder

[Image showing folder structure]

Then if you need to go back to CV2023.1 rename CV2023 to CV 2023.2 (first) and rename CV2023.1 to CV 2023

Then update to current version

---

**Toby Richards** - Sep 11, 2023

Is this the folder in C:\Program Files\Hexagon\CABINET VISION?

---

**Kevin_ValleyCabinet** - Sep 11, 2023

yes

---

**Kevin_ValleyCabinet** - Sep 11, 2023

Do the same for the S2M folder

---

**The Cabinet Visionary (TCV)** - Sep 11, 2023

I don't have a need to do this now, but just for interest sake and future reference, I need to ask:

Is there a step I am not seeing here? Surely you can't just rename the folder - CV will not find what it wants where it is set up to look. Do you change that path elsewhere as well??

Or are you having to do the renaming each time you want to run the other version again? Meaning running version is always "CV2023" folder etc. I know with pre-SQL Cabinet Visions I made an application that would swap databases for me. This enabled me, as support and reseller, to switch between client databases quickly on my own system.

---

**Kevin_ValleyCabinet** - Sep 11, 2023

The rename holds the other version CV2023.1 CV2023.2 

When installing lets say 23.3 make sure you copy the current CV2023 folder and then rename that folder to CV2023.2

so 23.3 will install in the CV2023 folder like normal

CV will only use the CV2023 folder so what ever version you want to use, make sure the folder is CV2023

So if needed to go back 23.2, Rename the CV2023 to CV2023.3 and then rename the CV2023.2 to CV2023

Run update version

I have not see any issues in doing this but this is just my testing and finds. But it works from what I can see.

I do the same for the S2M folders too.

If it does happen to fail, you still have the other folder to rename back and you are off and running

---

**The Cabinet Visionary (TCV)** - Sep 11, 2023

> Meaning running version is always "CV2023" folder

Okay so this is it indeed. 

Yeah the old database switching application I wrote did this too, with the Database folder(s). Have not needed to do it in later versions since about 2018, but good to know that this can still work. Thanks Kevin.

---

## Summary

The discussion reveals a practical solution for maintaining multiple Cabinet Vision versions:

1. **Rename existing installation folders** before installing new versions
2. **CV always looks for the standard folder name** (e.g., "CV2023") 
3. **Switch versions by renaming folders** - active version must have the standard name
4. **Apply same process to S2M folders**
5. **The Cabinet Visionary mentions** having created database switching applications for pre-SQL versions

This method allows testing new versions while maintaining rollback capability without complex reinstallation procedures.