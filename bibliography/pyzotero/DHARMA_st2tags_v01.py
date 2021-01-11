from pyzotero import zotero
zot = zotero.Zotero('1633743', 'group', 'SNTOlhPbtO3n21oq1Son78B1')
items = zot.everything(zot.top()) #collection Tamil: items = zot.everything(zot.collection_items('NYLTL87Y'))
# Chercher les shortTitles
for item in items:
    newtag1 = item['data'].get('shortTitle')
    zot.add_tags(item, newtag1)
    print(item['data']['key'], '+', newtag1)
