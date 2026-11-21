import pandas as pd

# *************************************************
# 1. Inladen van het ruwe CSV-bestand
bestandsnaam = 'Ruwe_Woningdata_Nederland_CBS.csv'
df = pd.read_csv(bestandsnaam, sep=';')

# *************************************************
# 2. Kolommen hernoemen naar 13 korte namen
df.columns = [
    'gemeente_code', 'gemeente', 'inwoners', 'woningvoorraad', 'woz_waarde_euro', 'perc_eengezins', 'perc_tussenwoning', 'perc_hoekwoning', 'perc_tweeondereenkap', 'perc_vrijstaand', 'perc_meergezins', 'perc_leegstand', 'perc_koopwoningen'
]

# We bekijken eerst de huidige types in de terminal
print("Huidige Datatypes Ruwe Import")
print(df.dtypes)

# We bekijken de eerste 10 rijen van de kolommen
print("De eerste 10 rijen van de kolommen")
print(df.head(10))

# *************************************************
# 3. Data opschonen: onzichtbare spaties weghalen en WOZ-waarde corrigeren
df['gemeente_code'] = df['gemeente_code'].str.strip()
df['gemeente'] = df['gemeente'].str.strip()
df['woz_waarde_euro'] = df['woz_waarde_euro'] * 1000

# Controleren of de rijen van de kolom 'woz_waarde_euro' zijn veranderd
print(df[['gemeente', 'woz_waarde_euro']].head(10))

# *************************************************
# 4. Data filteren: opsplitsen in landelijk gemiddelde (NL00) en gemeenten (GM)
landelijk_df = df[df['gemeente_code'] == 'NL00']
gemeenten_df = df[df['gemeente_code'].str.startswith('GM')]

# *************************************************
# 5. Opslaan in CSV-bestand
df.to_csv('Huizenmarkt_Nederland_Clean.csv', sep=';', index=False)