# Towards Linked Stage Graph 2.0
This repository documents the process of creating Linked Stage Graph 2.0 as an open performing arts research resource which reuses open standards and ontologies and enables an efficient and scientifically accurate exploration of historical performing arts data as well as an easy interconnection with data sets from various sources stored in archives, museums, theatre institutions and universities.
## Modeling Requirements

The requirements listed below were extracted from scientific literature in the domain of the performing arts, as well as workshops with domain experts in the performing arts. The requirement analysis is an ongoing process and will be extended as part of the iterative ontology development process. 

|   |Requirement|Description  |
| ------  | ------ | ------ |
| REQ1  | Context| For each entity in the data collection, provide as much context as possible. No entity in the performing arts exists on its own (e.g. archival object, performance, person, role, stage element) and should be viewed in its context to other entities.  |
|  REQ2 | Perspective | Provide various perspectives on performing arts data for data exploration to enable a holistic view.  |
| REQ3  | Interoperability | Enable the interconnection between disciplines, data sets, archives, performing arts institutes as well as regional and international efforts. |
| REQ4  |Persons and Functions  | All persons on, behind and in front of the stage of a performance and their roles and functions are relevant for research. |
| REQ5 | Change | Performing arts are dynamic and the change over time should be represented in terms of persons, occupations, stage design, etc. |
| REQ6  | Events | Performing arts data is often event-based. It should be distinguished between an original work, a production and the performance as an event.|
| REQ7  | Stage Elements | Objects on stage should be captured. If possible, the meaning of an object on stage should be represented (e.g. a chair as an object is used as a throne). |
| REQ8  | Querying | A data model that represents performing arts data should be as lightweight as possible to enable intuitive querying. |
| REQ9 |  Provenance| It has to be possible to verify and track research results, e.g. biographical data has to be linked to their data source. |
| REQ10  | Data Quality | The quality of the data used in performing arts research has to be clear and should be quantifiable. |

These requirements are based on the following publications: 
- Bollen, Jonathan. Data Models for Theatre Research: People, Places, and Performances (2016)
- van Oort, T., & Noordegraaf, J. (2020). Structured Data for Performing Arts History: An Introduction to a Special Issue of Data Papers, Research Data Journal for the Humanities and Social Sciences, 5(2), 1-12. 
- Sofer, Andrew. “Getting on with Things: The Currency of Objects in Theatre and Performance Studies.” Theatre Journal 68 (2017): 673 - 684. 
- Probst, Nora and Pinto, Vito. "Re-Collecting Theatre History: Theaterhistoriografische Nachlassforschung mit Verfahren der Digital Humanities" In Neue Methoden der Theaterwissenschaft edited by Benjamin Wihstutz and Benjamin Hoesch, 157-180. Bielefeld: transcript Verlag, 2020. 
- Leonhardt, Nic. "Digital Humanities and the Performing Arts: Building Communities, Creating Knowledge." In Keynote address, SIBMAS/TLA Conference, New York City, vol. 12. 2014.
- Weiberg, Birk. "Modeling Performing Arts: On the Representations of Agency." Arti dello Spettacolo/Performing Arts 6 (2020): 50-56.
- Martin Bradley & Aisling Keane (2015) The Abbey Theatre Digitization Project in NUI Galway, New Review of Information Networking, 20:1-2, 35-47, 
- Beck, Julia, Michael Büchner, Stephan Bartholmei, and Marko Knepper. 2017. Performing Entity Facts: The Specialised Information Service Performing Arts. Datenbank Spektrum 17 (1): 47–52.
- Blom, Frans R. E., Harm Nijboer, and Rob van der Zalm. 2020. ONSTAGE, the Online Data System of Theatre in Amsterdam from the Golden Age to Today. Research Data Journal for the Humanities and Social Sciences 5 (2): 27–40. 
- Bradley, Martin, and Aisling Keane. 2015. The Abbey Theatre Digitization Project in NUI Galway. New Review of Information Networking 20 (1-2): 35–47.
- Estermann, Beat, and Frédéric Julien. 2019. A Linked Digital Future for the Performing Arts: Leveraging Synergies along the Value Chain. In Canadian Arts Presenting Association (CAPACOA) in cooperation with the Bern University of Applied Sciences.
- McMullan, Anna, Trish McTighe, David Pattie, and David Tucker. 2014. Staging Beckett: constructing histories of performance. Journal of Beckett Studies 23 (1): 11–33.
- Thull, Bernhard, Kerstin Diwisch, and Vera Marz. 2015. Linked Data im digitalen Tanzarchiv der Pina Bausch Foundation. In Corporate Semantic Web: Wie semantische Anwendungen in Unternehmen Nutzen stiften, 259–275.

## Leveraging Existing Ontologies for Historical Performing Arts Data
### Example Modeling 1:
#### Leveraging the Swiss Performing Arts Data Model for Linked Stage Graph on the example of the performance "Twelfth Night". Green boxes represent classes, red boxes instances already present in the KG, yellow boxes are instances which have to be newly created to fit the model.
![Figure 1](https://github.com/ISE-FIZKarlsruhe/LinkedStageGraph/blob/940205a7d053dfa6bc4df2fbd382cde349293c2f/LinkedStageGraph2.0/img/LSG_SPAmodeling_TopDown.jpg)
![Figure 2](https://github.com/ISE-FIZKarlsruhe/LinkedStageGraph/blob/940205a7d053dfa6bc4df2fbd382cde349293c2f/LinkedStageGraph2.0/img/LSG_SPAmodeling_BottomUp.jpg)
