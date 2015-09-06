## Chadtech Tracker or Non-Cloud Data Delimiter

CToNCDD is a utility made for myself to handle a really specific use case that I have run into. A tracker, as I am told, is a music interface where notes are listed vertically, and read through by a computer. They were apparently common in old video game music composition software.

It was my intention to make my own tracker, and tie it to my own audio generation software. I realized all that the only difference between google sheets, and a tracker, is that a tracker is committed to a music application. I played with the possibility of using google sheets as a tracker, and I ran into some problems. The problems had nothing to do with using a csv output generated from google sheets to make music, but instead had to do with google sheets being cloud software. The problems were as listed:

  > * You can only export as csv, rather than save. By saving, you are updating a known data location. When exporting you have to re-sepcify the export location, and you cannot write over existing data. The user could specify the data location and the file name each time, but this is costly, especially if the user is updating the data very frequently.
  > * Since the data isnt stored on your computer, but instead Googles, you have to request and download the data each time you would like to utilize the data.

I therefore needed csv software that could save directly to csv, and remember the location of the file being updated. I was going back in time as far as personal data management is concerned. 


# Glossary
  * 'xCor' and 'yCor' stand for 'x coordinate' and 'y coordinate'
  
  * 'xOrg' and 'xOrg' stand for 'x origin' and 'y origin', meaning a point of reference from which the remainder of a drawing is made.

  * 'ctx' stands for 'context', as in, canvas context.
  
  * 'cell' unfortunately doesnt refer to the cell itself, but its
  dimensions.

  * 'CS' stands for 'Color Scheme'.