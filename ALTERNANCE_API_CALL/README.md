## API call to search effectively for a apprentice position (alternance) or companies likely to hire an apprentice in a given area

### Summary  
This script simulates the behavior of the la bonne alternance API website while also handling the ROME codes used in the query in a more implicit way (letting the user specifficaly choose its job's interests, hence the ROME codes passed to the API).  

### Description  
The script search for rome codes ('Répertoire Opérationnel des Métiers et des Emplois') in relation to a string search like 'data'.   

These ROME codes are then used with *la bonne alternance* API to find current job offers and also companies in the region that are likely to hire at the time (based on historical data) for these type of ROME codes.   

These calls recreate the behavior of their beta application available at : https://labonnealternance.pole-emploi.fr/ although it is not clear how they transform the job string search into romes codes. (for example, for the 'data' string search, I wasn't interested in all jobs (undestood as professions or careers) provided by the pole emploi API. This script offers the possibility for the user to select the jobs that they want to keep to then be used in the la bonne alternance API call).  

Multiple rome codes can be passed to la bonne alternance API calls. The API also handles location (lat, lon), radius, insee code and sources as parameters. For this application, these parameters are fixed to the Toulouse area but can easily be chaged to accommodate other needs. 

Id and secret codes are needed to use the Pole Emploi's APIs. These can be generated easily and at no charge at https://www.emploi-store-dev.fr/portail-developpeur-cms/home.html (selecting the correct API, in this case ROME API).  

## Outputs  
The script delivers a list of current apprentice positions returned by the la bonne alternance API and their respective url to go and check the role as well as a list of companies that could potentially welcome me in september for an apprentice position in the area.  

## Screenshots 
### Option to choose specific (and multiple) professions for the search  
![](https://github.com/camilodlt/rtidy-python/blob/cbccd18560088578c3cd60746064ebd8b0cbb614/ALTERNANCE_API_CALL/screenshots/Screenshot%202021-04-02%2015.00.05.png)
### Positions found by the API   
![](https://github.com/camilodlt/rtidy-python/blob/cbccd18560088578c3cd60746064ebd8b0cbb614/ALTERNANCE_API_CALL/screenshots/Screenshot%202021-04-02%2015.00.38.png)
### Companies found by the API likely to hire  
![](https://github.com/camilodlt/rtidy-python/blob/cbccd18560088578c3cd60746064ebd8b0cbb614/ALTERNANCE_API_CALL/screenshots/Screenshot%202021-04-02%2015.00.51.png)
