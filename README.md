# Elections-analytics
Perform some analytics on real data from one hundred years of elections. The data comes from ParlGov1, a database for political science.


1.

For each of the past 20 years (1996 to 2016, both inclusive), for each country, and for each political party, report the name of country, the name of the party, and a description of the range into which the number of valid votes it received falls, in the following format: (lb-ub], where lb is the lower bound of the range and ub is the upper bound of the range (for example, (20-30].) These are the range values to consider: non-zero and below 5 percent of valid votes inclusive, 5 to 10 percent of valid votes inclusive, 10 to 20 percent of valid votes inclusive, 20 to 30 percent of valid votes inclusive, 30 to 40 percent of valid votes inclusive, and above 40 percent of valid votes. If there is more than one election in the same country in the same year, use the average (across those elections) of the percent of valid votes that a party received. The range values are defined only for the parties and elections for which the number of votes are recorded. Where there was no parties in a given range, do not report that range. Where a country does not have any elections in a year, do not include it in the results.

======================================================================================
Attribute      |      Description 
year                  year
countryName           name of a country
voteRange             the percentage range that the party falls into
partyName             short name of a party
Order by              year descending, countryName descending, voteRange descending and partyName descending
Everyone?             Every year where at least an election has happened should be included.
Duplicates?           No year-country-party combination occurs more than once.

=======================================================================================

2. 

Find Winners. Find parties that have won more than 3 times the average number of winning elections of parties of the same country. Report the country name, party name and its party family name along with the total number of elections they have won. For each party included in the answer, report the id and year of the mostly recently won election.


=======================================================================================
Attribute        |            Description
countryName                   Name of the country
partyName                     Name of the party
partyFamily                   Name of the family of a party
wonElections                  Number of elections the party has won
mostRecentlyWonElectionId     The id of the election that was most recently won by this party
mostRecentlyWonElectionYear   The year of the election that was most recently won by this party
Order by                      The name of the country ascending,then the number of won elections ascending, then the name of         the party descending.
Everyone?                     Include only countries and parties who meet the criteria of this question.
Duplicates?                   Countries and party families can be included more than once with different party names.


========================================================================================
3.

Do citizens participate more? The number of eligible voters, votes votes, and valid votes have been recorded for each election. Analysts would like to know if citizens of countries participate enthusiastically in elections. The participation ratio of an election is the ratio of votes cast to the number of citizens who are eligible to vote (the “electorate”). Note the participation ratio is a value between zero and one. As part of this question, you will need to compute the participation ratio for each country, each year. If more than one election happens in a year in a country compute the average participation ratio across those elections.
Write a query to return the countries that had at least one election over the last 15 years, 2001 to 2016 inclusive, and whose average election participation ratios during this period are monotonically non-decreasing (meaning that for Year Y and Year W, where at least one election has happened in each of them, if Y < W,then average participation in Year Y is ≤ average participation in Year W). For such countries, report the name of the country and the average participation ratio per year for the last 15 years.

=========================================================================================
Attribute            |            Description
countryName                       Name of the country
year                              year
participationRatio                The average percentage ratio of citizens who cast vote in this year
Order by                          The name of country descending then year descending
Everyone?                         Include only countries that meet the criteria of this question.
Duplicates?                       No rows if there are no elections for a country in the last 15 years.

=========================================================================================

4. 

Left-right histogram. The database records several policy positions of political parties, including their “left-right dimension”. Suppose the left-right range is divided into 5 interval ([0,2), [2,4), [4,6), [6,8) and [8,10]). Create a table that is, essentially, a histogram of parties and their left-right position.

========================================================================================
Attribute               |                Description
countryName                              Name of the country
year                                     year
participationRatio                       The average percentage ratio of citizens who cast vote in this year
Order by                                 The name of country descending then year descending
Everyone?                                Include only countries that meet the criteria of this question.
Duplicates?                              No rows if there are no elections for a country in the last 15 years.

=========================================================================================

5. 
Committed Parties.
A committed party is the one that has been a member of all cabinets in their country over the past 20 years. For each country, report the name of committed parties, their party families and their “regulation of the economy” value.

=========================================================================================
Attribute               |                Description
countryName                              Name of a country
partyName                                Name of a committed party
partyFamily                              Name of a committed party’s family if exists, otherwise, null.
stateMarket                              Regulation of the economy property of the party if exists, otherwise, null.
Order by                                 countryName ascending, then partyName ascending, then stateMarket descending
Everyone?                                Include only countries with committed parties
Duplicates?                              There can be no duplicates.

========================================================================================

6. 
Sequences of Cabinets. For each country, report the cabinets formed over time.

========================================================================================
Attribute               |                Description
countryName                              Name of a country
partyName                                Name of a committed party
partyFamily                              Name of a committed party’s family if exists, otherwise, null.
stateMarket                              Regulation of the economy property of the party if exists, otherwise, null.
Order by                                 countryName ascending, then partyName ascending, then stateMarket descending
Everyone?                                Include only countries with committed parties
Duplicates?                              There can be no duplicates.

========================================================================================

7.

Election Alliances A political alliance, is an agreement for cooperation between different political parties often for purposes such as winning an election mutually. We assume each alliance is led by a party. Zero, one or more than one alliance might be formed in an election. In the election result table, the row corresponding to the election result of a party that participates in an alliance links to the alliance leader party by recording the election result id of the leader in alliance id attribute. The alliance id of a leader is recorded as NULL. Report the pair of parties that have been allies with each other in at least 30% of elections that have happened in a country.

=======================================================================================
Attribute               |                 Description
countryId                                 id of a country
alliedPartyId1                            id of an allied party
alliedPartyId2                            id of an allied party
Order by                                  countryId descending, then alliedPartyId1 descending, then alliedPartyId2 descending
Everyone?                                 Every allied pair that satisfy the condition.
Duplicates?                               No pair can be included more than once.
                                          To avoid symmetric pairs (“pseudo-duplicates”) solely include pairs that satisfy   alliedPartyId1 <alliedPartyId2.
                                          
========================================================================================
