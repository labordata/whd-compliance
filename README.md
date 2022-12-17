# Wage and Hour Division Investigation and Enforcement Action Data

The Department of Labor's [Wage and Hour Division](https://en.wikipedia.org/wiki/Wage_and_Hour_Division) investigates and enforces a number of labor laws. The completed investigations, from 2005 onwards, are published quarterly on the [Department of Labor Enforcement Dat Catalog](https://enforcedata.dol.gov/views/agency_tools.php).

This repository contains code to pull down the data and normalize the data into set of three tables.

* cases: information about the subject and timing of the investigation
* violations: information about violations found by the division
* flsa_details: for violations of the [Fair Labor Standards Act](https://en.wikipedia.org/wiki/Fair_Labor_Standards_Act_of_1938), this table indicates what types of violations were found (minimum wage, overtime, or retribution).

The data can be viewed and download on the [labordata.bunkum.us data warehouse](https://labordata.bunkum.us/whisard-3cb3a62).
