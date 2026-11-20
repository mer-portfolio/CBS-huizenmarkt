-- Aanmaak database 'portfolio_huizenmarkt'

-- 1. Tabel aanmaken voor de ruwe CBS-woningmarktdata

CREATE TABLE public.huizenmarkt_nederland (
    gemeente_code TEXT,
    gemeente TEXT,
    inwoners INT,
    woningvoorraad INT,
    woz_waarde_euro INT,
    perc_eengezins FLOAT,
    perc_tussenwoning FLOAT,
    perc_hoekwoning FLOAT,
    perc_tweeondereenkap FLOAT,
    perc_vrijstaand FLOAT,
    perc_meergezins FLOAT,
    perc_leegstand FLOAT,
    perc_koopwoningen FLOAT
);

-- 2.1 View maken voor nominale percentages

CREATE OR REPLACE VIEW public.nominale_percentages AS SELECT
	gemeente_code,
	gemeente,
	inwoners,
	woningvoorraad,
	(woz_waarde_euro * 1000) AS woz_waarde,
	(perc_koopwoningen / 100) AS perc_koopwoningen,
	(perc_leegstand / 100) AS perc_leegstand,
	(perc_eengezins / 100) AS perc_eengezins,
	(perc_meergezins / 100) AS perc_meergezins,
	(perc_tussenwoning / 100) AS perc_tussenwoning,
	(perc_hoekwoning / 100) AS perc_hoekwoning,
	(perc_tweeondereenkap / 100) AS perc_tweeondereenkap,
	(perc_vrijstaand / 100) AS perc_vrijstaand
	FROM public.huizenmarkt_nederland
	WHERE gemeente_code LIKE 'NL00%';

-- 2.2 View maken voor nominale aantallen

CREATE OR REPLACE VIEW public.nominale_aantallen AS SELECT
	gemeente,
	inwoners,
	woningvoorraad,
	woz_waarde,
	ROUND(woningvoorraad * perc_koopwoningen) AS aantal_koopwoningen,
	ROUND(woningvoorraad * perc_leegstand) AS aantal_leegstand,
	ROUND(woningvoorraad * perc_eengezins) AS aantal_eengezins,
	ROUND(woningvoorraad * perc_meergezins) AS aantal_meergezins,
	ROUND(woningvoorraad * perc_tussenwoning) AS aantal_tussenwoning,
	ROUND(woningvoorraad * perc_hoekwoning) AS aantal_hoekwoning,
	ROUND(woningvoorraad * perc_tweeondereenkap) AS aantal_tweeondereenkap,
	ROUND(woningvoorraad * perc_vrijstaand) AS aantal_vrijstaand
	FROM public.nominale_percentages;

-- 2.3 View maken voor steden percentages

CREATE OR REPLACE VIEW public.steden_percentages AS SELECT
	gemeente,
	inwoners,
	woningvoorraad,
	(woz_waarde_euro * 1000) AS woz_waarde,
	(perc_koopwoningen / 100) AS perc_koopwoningen,
	(perc_leegstand / 100) AS perc_leegstand,
	(perc_eengezins / 100) AS perc_eengezins,
	(perc_meergezins / 100) AS perc_meergezins,
	(perc_tussenwoning / 100) AS perc_tussenwoning,
	(perc_hoekwoning / 100) AS perc_hoekwoning,
	(perc_tweeondereenkap / 100) AS perc_tweeondereenkap,
	(perc_vrijstaand / 100) AS perc_vrijstaand
	FROM public.huizenmarkt_nederland
	WHERE gemeente_code LIKE 'GM%';

-- 3.1 Query Top 10 steden

SELECT
	gemeente,
	inwoners,
	woningvoorraad,
	woz_waarde,
	perc_koopwoningen,
	perc_leegstand
	FROM public.steden_percentages
	ORDER BY woningvoorraad DESC
	LIMIT 10;

-- 3.2 Query Fysieke Woningverdeling top 3 Steden

SELECT
	gemeente,
	woningvoorraad,
	ROUND(woningvoorraad * perc_eengezins) AS aantal_eengezins,
	ROUND(woningvoorraad * perc_meergezins) AS aantal_meergezins,
	ROUND(woningvoorraad * perc_tussenwoning) AS aantal_tussenwoning,
	ROUND(woningvoorraad * perc_hoekwoning) AS aantal_hoekwoning,
	ROUND(woningvoorraad * perc_tweeondereenkap) AS aantal_tweeondereenkap,
	ROUND(woningvoorraad * perc_vrijstaand) AS aantal_vrijstaand
	FROM public.steden_percentages
	WHERE gemeente LIKE 'Amsterdam%'
	OR gemeente LIKE 'Rotterdam%'
	OR gemeente LIKE '%s-Gravenhage%'
	ORDER BY woningvoorraad DESC;

-- 3.3 Query Landelijk Gemiddelde versus Stad

SELECT
	gemeente,
	woningvoorraad,
	(perc_eengezins - 63) AS verschil_eengezins,
	(perc_meergezins - 37) AS verschil_meergezins,
	(perc_tussenwoning - 29) AS verschil_tussenwoning,
	(perc_hoekwoning - 13) AS verschil_hoekwoning,
	(perc_tweeondereenkap - 9) AS verschil_tweeondereenkap,
	(perc_vrijstaand - 13) AS verschil_vrijstaand
	FROM public.huizenmarkt_nederland
	WHERE gemeente_code LIKE 'GM%'
	AND (gemeente LIKE 'Amsterdam%'
	OR gemeente LIKE 'Rotterdam%'
	OR gemeente LIKE '%s-Gravenhage%')
	ORDER BY woningvoorraad DESC;
