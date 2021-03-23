/*
    Dit bestand is er voor bedoeld om de integrity rules die in het TO staan te testen, wanneer deze business rules daadwerkelijk geimplementeerd worden.
 */

--Integrity rule 1: Als een product van het type case of module is, moet er voor dit product een Horizontal Pitch waarde worden opgenomen.
Exec sp_ModOrCaseThenHP 
	@Productcode = 123123,
	@Productnaam = 'Oscillator mod',
	@inkoopprijs = 50.20
	@verkoopprijs = 75.00
	@Beschrijving = 'Mooie oscillator',
	@Inset = 0
	@Type = 'Module',
    @HPWaarde = 0
/*
    Uitkomst:   Er wordt gecontroleerd op type van het product, wanneer deze type case of module is, zal de HP waarde opgenomen moeten worden.
                De HP waarde wordt gecontroleerd en krijgt foutmelding omdat deze niet de juiste waarde heeft.
 */

--Integrity rule 2: Als een product van het type module is moet de functie van de module worden opgenomen.
exec sp_FunctieAlsModule
	@Productcode = 123123,
	@Functie = 'case'
/*
    Uitkomst:   Toegevoegd product wordt gecontroleerd op type product. Type product is module, dus zal er een valide functie in meegegeven moeten worden.
                Functie is niet valide dus verschijnt er een foutmelding.
 */

--Integrity rule 3: Een product kan een Productvariant, een ProductMetHP/Productset of een Product zijn, nooit iets tegelijk.
insert into TYPE(
	1,
	'Oscillator')
insert into TYPE(
    2,
    'Case'
)

insert into PRODUCT values(
	123123,
	'Oscillator mod',
	50.20,
	75.00,
	'Mooie oscillator',
	0)
insert into PRODUCT_TYPE(
	123123,
	1)
insert into PRODUCT_TYPE(
    123123,
    2
)

/*
    Uitkomst:   Product wordt toegevoegd, product wordt neer gezet als ProductMetHP.
                Foutmelding ontstaat wanneer product nog een producttype krijgt.
 */

--Integrity rule 4: Een product dat een variant heeft kan nooit een losstaand product zijn.
exec ps_InsProdInFac
	@Oroductcode = 123123,
	@ProductVariant = '',
	@Factuurnummer = 1 ,
	@Aantal = 1

/*
    Uitkomst: Product wordt toegevoegd aan factuur, krijgt foutmelding als het product een variant heeft maar deze niet benoemd wordt.
 */

--Integrity rule 5: Een factuur zal altijd minimaal 1 regel moeten hebben van of Factuurregel_Product of Factuurregel_Variant
exec sp_InsFactuur
	@Factuurnummer = 1

/*
    Uitkomst:   Factuur wilt toegevoegd worden maar heeft geen regel van of Factuurregel_Product of Factuurregel_Variant
                Er verschijnt een foutmelding dat het minimaal 1 regel moet bevatten.
 */