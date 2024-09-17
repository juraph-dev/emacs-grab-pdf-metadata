# emacs-grab-pdf-metadata
Simple elisp function to retreive metadata of a PDF file, rename and store it, add it to a bibtex bibliography and add it to a reading list.
I have been using a workflow inspired by the wonderful post [on a emacs research workflow](https://koustuvsinha.com/post/emacs_research_workflow/) for a while now, and while it works fantastically, I found myself needing to extend it a bit. Often, I'll be sent a paper, or will find them while browsing the internet. I wanted to be able to simply open the PDF straight from the browser, give it a skim, and quickly add it to my reading list if I wanted to. This function facilitiates that, in that it:
1. Uses [emacs-zotero](https://gitlab.com/fvdbeek/emacs-zotero) to retrieve the pdf metadata
2. Renames the file appropriately, and copies it to my papers directory
3. Adds an entry to my bibtex bibliography, so I can reference it later without friction.
4. Adds the paper, with a link to the file to my reading list so that if I don't immediately read it, I don't forget it exists.

For the best experience, bind the function to a key, so you can call it while [reading it in emacs](https://github.com/vedang/pdf-tools)

Hopefully this will save someone some effort in the future with trying to achieve something similar!
