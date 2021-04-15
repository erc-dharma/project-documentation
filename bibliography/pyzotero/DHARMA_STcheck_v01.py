# Written by Axelle Janiak for DHARMA - april 2021
from pyzotero import zotero
zot = zotero.Zotero('1633743', 'group', 'SNTOlhPbtO3n21oq1Son78B1')
print("Retrieving Library...")
items = zot.everything(zot.top())

shortTitles  = []
# Récupérer les shortTitle
for i, item in enumerate(items):
    shortTitles.append(item['data'].get('shortTitle'))

seen = {}
duplicates = []

for shortTitle in shortTitles:
    if shortTitle not in seen:
        seen[shortTitle] = 1
    else:
        if seen[shortTitle] == 1:
            duplicates.append(shortTitle)
        seen[shortTitle] += 1

print(duplicates)
