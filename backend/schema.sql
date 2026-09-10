-- Clients table
CREATE TABLE IF NOT EXISTS clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  company_name TEXT NOT NULL,
  address TEXT,
  city TEXT,
  pin_code TEXT,
  state TEXT,
  phone1 TEXT,
  phone2 TEXT,
  gst_no TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bills table
CREATE TABLE IF NOT EXISTS bills (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_no TEXT NOT NULL,
  bill_date TEXT NOT NULL,
  client_id INTEGER,
  branch TEXT,
  state_code TEXT,
  total_freight REAL,
  amount_in_words TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  note TEXT,
  FOREIGN KEY (client_id) REFERENCES clients(id)
);

-- Bill items table
CREATE TABLE IF NOT EXISTS bill_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_id INTEGER,
  sr_no INTEGER,
  item_date TEXT,
  vehicle_no TEXT,
  from_location TEXT,
  to_location TEXT,
  lr_no TEXT,
  weight TEXT,
  freight REAL,
  FOREIGN KEY (bill_id) REFERENCES bills(id)
);


-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert existing clients

INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('BAMKIN TREASURE MOLDERS PRIVATE LTD', 'PLOT NO-611 AND 614. GIDC ESTATH, ANKLESHWAR', 'Bharuch', '393002', 'Gujarat[24]', '7043739211', '', '24ABDCS8842F1Z9');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SAMKIN SUSTAINABLE SOLUTIONS PRIVATE LIMITED', 'PLOT NO 5, SAMKIN SUSTAINABLE SOLUTIONS PRIVATE LIMITED, PALEJ, Palej GIDC, Palej', 'Bharuch', '392220', 'Gujarat[24]', '7043739211', '', '24ABJCS0917R1ZU');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Jewel Consumer PVT LTD', 'Plot No. 209214, Village luna', 'baroda', '391440', 'Gujarat[24]', '8156082993', '', '24AAACB8634Q1ZA');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('DHYANI ENTERPRISE', 'CITY SURVEY NO. 7292, 7293 SURVEY NO 691, PLOT NO. 122 AND 123, TARSADI, TALUKO MANGROL', 'SURAT', '394120', 'Gujarat[24]', '9712778872', '', '24AAQFD1715M1ZA');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('RAJIV PETROCHEMICALS PVT LTD', 'Building No: 4, RAJIV HOUSE, Road/Street: NR. NAVRANGPURA POST OFFICE, NAVRANGPURA', 'Ahmedabad', '380009', 'Gujarat[24]', '9909503544', '8488834941', '24AAACR7289P2ZM');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Aakash Packaging Unit-2', 'Plot No. A-23/1, Ichchapore GIDC, Hazira Road', 'Surat', '394510', 'Gujarat[24]', '261-2977209', '9824077693', '24AANFA9091N2ZS');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Graffias Polymers Pvt. Ltd.', 'Plot No.8206/a, Road No.82, Sachin Gidc', 'Surat', '394230', 'Gujarat[24]', '8738893508', '9825120023', '24AAICG0530C1ZB');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('NCG HYGIENE AND SURGICAL POLYTECH', 'INDUSTRIES BLOCK NO 23, PLOT NO.10 TO 14, PROPERTY NO.6662', 'Vadodara', '394110', 'Gujarat[24]', '9429077177', '', '24AAWFN4872B1Z1');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SURNI LABS', '470, G.I.D.C., Manjusar, tal. Savli', 'Vadodara', '391776', 'Gujarat[24]', '9824011379', '8866446335', '24ABNFS3139E1Z7');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('UNIQUE EXIM', 'S R NO. 55, BLOCK 46, PLOT NO. J/4, EKTA INDUSTRIAL, ESTATE, PIPODARA', 'Surat', '394110', 'Gujarat[24]', '7874268851', '', '24AAFFU1488F175');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Climax Synthetics Pvt. Ltd', 'A/1, 835-836, GIDC Makarpura', 'Vadodara', '390010', 'Gujarat[24]', '9909922056', '9909922069', '24AABCC0519Q1ZO');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SBS POLYCHEM PVT LTD', 'Haldar, Dist -Bharuch', 'Bharuch', '392001', 'Gujarat[24]', '7990410114', '9979087878', '24AAMCS2186A1ZJ');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('TOYO INK PVT LTD', '2/23, Dahej D-II, vill. Jolwa', 'Bharuch', '392130', 'Gujarat[24]', '7069002501', '7227932324', '24AACCT5137A1ZV');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('PATKAR EXTRUSIONS PVT LTD', 'Plot No. 4202-3, GIDC, Ankleshwar ', 'Bharuch', '393002', 'Gujarat[24]', '2646 238757', '7490030314', '24AABCP1734C1ZI');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SHREENATHJI PLASTIC INDUSTRIES', '27B, Shop No, G-2, MKHFUZ BUILDING Road No-2, Udhana', 'Surat', '394210', 'Gujarat[24]', '9824177008', '8690344733', '24AKPPD4348M1Z7');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('CORAPLAST INDUSTRIES', '27B, SURVEY No 180, UDWADA, PARIYA ROAD, DUNGARI GAM, PARDI', 'Valsad', '396185', 'Gujarat[24]', '9099021882', '7434936399', '24AADFB7416Q1Z7');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('BALMUKUND POLYMER', 'Plot No 37 48 Yogi Estate 2, NR 66 KVA Sub Station, GIDC, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '9722662828', '', '24AATFB9508R1ZK');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Bhagwati Polyweave PVT LTD', 'Plot No B-14/20 Hojiwala IND Estate Vanz, Sachin Palsana Road', 'Surat', '394230', 'Gujarat[24]', '9825493986', '9106313785', '24AACCB6731C1Z7');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('PEM PACKAGING', 'Plot No 31 32, Yogi IND Estate, NR 66 KVA Sub Station, GIDC, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '9824145018', '9737253795', '24AAQFP9366A1Z0');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('HINDUSTAN PACKAGING', 'Plot No. 32, GIDC, Panoli', 'Bharuch', '394115', 'Gujarat[24]', '8527022599', '', '24AAMFH2951H1ZD');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('ARIHANT RASAYAN', 'C-9, Janatanagar, Nr Vatika Bunglow, Vasana Road', 'Vadodara', '390015', 'Gujarat[24]', '9825265899', '', '24AACFA9075H1ZH');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('3 D PLAST', 'C1/297, GIDC ESTATE, POR RAMANGAMDI, POR', 'Vadodara', '391243', 'Gujarat[24]', '9825082823', '9426333696', '24AAFFD3353A1Z4');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('KARNAVATI WOVEN SACK INDUSTRIES', 'A-1-67/1&2, GIDC, Estate, Phase-1, B/H Jamnagar Transport, Narmadanagar', 'Bharuch', '392015', 'Gujarat[24]', '9427116662', '9924816662', '24AADFK4417C1ZW');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('MARKLON TEX IN PRIVATE LTD', '2530, ANJANI TEXTILE PARK SEGWA PARIYA ROAD', 'Surat', '394540', 'Gujarat[24]', '9974525237', '', '24AAHCM7351EIZL');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('NEWTECH FILAMENTS', 'Plot No C-28/20, Road No-2, Hojiwala Industrial, estate, Susml gate no-1, Sachin', 'Surat', '394230', 'Gujarat[24]', '9727737700', '9712683400', '24AAKFN8457E1Z2');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SHREE SHYAM POLY & MASTREBATCH PVT LTD', 'BLOCK NO 602, NATIONAL HIGHWAY 64, VILLAGE KOSAMBA, TAL MANROL', 'Surat', '394125', 'Gujarat[24]', '9571180090', '9825128735', '24ABHCS8349F1Z3');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('PARAGON Irrigation PVT LTD', 'Plot No 102, GIDC, Makarpura', 'Vadodara', '390010', 'Gujarat[24]', '9712837797', '9228487451', '24AABCP2708E1ZX');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Rivulis Irrigation India PVT LTD', 'Block No 593/B, Vadu Village, Taluka Padra', 'Vadodara', '391440', 'Gujarat[24]', '9712837797', '9228487451', '24AACCF4120F1ZA');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Meet Packaging', 'Plot No 215/1, GIDC, Palej', 'Bharuch', '392220', 'Gujarat[24]', '9824145018', '9737253797', '24ADZPP9886B1ZP');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('ZIPLINE', 'Por Industrial PRK Plot No 178, Por Taluka', 'Vadodara', '391243', 'Gujarat[24]', '9723539258', '7574897246', '24AABFZ6518P1ZM');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Plastocon Industries PVT LTd', 'Plot No 5219 & 5220, Nr. Seven Water Tanks, GIDC, Estate, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '9904001100', '9377560010', '24AALCP2032K1ZH');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('DEEP POLYMERS', 'Plot No 104/46, GIDC, Palej', 'Bharuch', '392220', 'Gujarat[24]', '8238377755', '8160718085', '24AAPFD3824Q1ZX');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('ZIPTECH', 'SAHYOG HOTEL, PLOT NO 241 AND 270, POR INDUSTRIAL PARK, VILLAGE POR, ANKHI', 'Vadodara', '391243', 'Gujarat[24]', '9723539258', '', '24AEBPV7458N2ZR');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('VAIBHAV POLY FILM INDUSTRIES', 'B-403, Blue Sparsh Near Saurabh Police Station, Behind TGB Restaurant Road, Pal Gam', 'Surat', '395009', 'Gujarat[24]', '8140539425', '8866880258', '24BMUPD5095D1ZX');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('C-K-ZIPPER', 'Por Industrial PRK Plot No 179, Por Taluka', 'Vadodara', '391243', 'Gujarat[24]', '9723539258', '7574897246', '24AADCC7700M1ZP');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('BETA POLY PLAST PVT LTD', 'Plot No 179, Near UPL Rotary Library, GIDC, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '9426781812', '7984234905', '24AAHCB5413G1Z1');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('INTERPLASTICA PVT LTD', 'GROUND FLOOR, PLOT NO. 1103/1104, G.I.D.C. ESTATE, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '9824134499', '9723344499', '24AAACI4358L1ZG');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('NAGINDAS HIRALAL BHAYANI', 'PLOT NO-2801/3, E WING, GIDC, PANOLI, Ankleshwar', 'Bharuch', '393001', 'Gujarat[24]', '9157691009', '9638625252', '24AACFN2803L1ZH');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('PACKEDGE Industries PVT LTD', 'Block no 498, Paiki Plot no B-1, N.H No 8 Palsana', 'Surat', '394315', 'Gujarat[24]', '9723706688', '8160995394', '24AAFCA2544R1ZF');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SHISH INDUSTRIES LTD', 'Unit-1 and Unit-2, Block No 390/1 01 A Type Plot, Techno Park', 'Surat', '394125', 'Gujarat[24]', '8320458126', '8490800833', '24AAYCS6904J1ZQ');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Grow Pack India PVT LTD', 'A1-4009, GIDC, Anklehswar ', 'Bharuch', '393002', 'Gujarat[24]', '9311123945', '8199940904', '24AAICG0554A1Z7');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Radhadarshan Petropack LLP', 'Block No 103, Survey No 87/1/A. Kim Mandvi Road. Bhatkol, Kim', 'Surat', '394110', 'Gujarat[24]', '9374266521', '8140665000', '24AASFR6922J2ZO');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Dy.Conservator of Forests Social Forestry Division Navsari', 'Jilla seva sadan C- Block, Junathana', 'Navsari', '396445', 'Gujarat[24]', '02637-258193', '8306463033', '24AAAGD1316F1Z6');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Aparna Polyplast PVT LTD', 'A4/3, HOJIWALA INDUSTRIAL ESTATE, ROAD NO.11. VILLAGEVANZ, SACHIN', 'Surat', '394230', 'Gujarat[24]', '9825493986', '9106313785', '24AAFCA1662C1Z9');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Daksh Trade link', 'Shed No - 1/2, Patel Estate, Near Bajrang Estate, Aslali', 'Ahmedabad', '382427', 'Gujarat[24]', '8000714428', '9726899335', '24AAMFD0826D2ZU');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SARA Health Care', 'SURVEY NO. 50 B/S AMAR ENGINEERING NR. GEB SUB STATION, PADRA, JAMBUSAR ROAD, MAHUVAD', 'Vadodara', '391440', 'Gujarat[24]', '9898960234', '7303526392', '24ACVFS0891G1ZO');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Range Forest Officer, GODHRA East', 'Deputy Conservator of Forests, Civil lines Road, Godhra', 'Panchmahal', '389001', 'Gujarat[24]', '9979990103', '02672-242210', '24AAAGD3492G1ZN');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Deputy Conservator of Forests', 'Social Forestry, Van Bhavan, Ghangeshwar mahadev Road, Adajan Division ', 'Surat', '395010', 'Gujarat[24]', '9316396908', '0261-2733831', '24AAAGD1116R1DS');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Deputy conservator of forests (Surat) forest division', 'Onebhavan Ground floor, Gangeshwar Mahadev mandir, Shivaji chok, apposite demart, Adajan', 'Surat', '395009', 'Gujarat[24]', '9662341778', '', '24AAALD0939R1ZV');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Vikram Hygiene Products (A unit of Vikram nuvotech India PVT LTD)', 'Plot no E49, Near IPCL Reliance Phase 2, GIDC, Dahej', 'Bharuch', '392130', 'Gujarat[24]', '7211116635', '9974055597', '24AABCP3984C2ZK');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Pristius Pack LLP', 'Plot no 63, Por industrial Estate, Por', 'Vadodara', '391243', 'Gujarat[24]', '9979842202', '', '24ABCFP1331N1ZC');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Rubicon PVC Products', 'Plot no D-51/4, Road No 21, Hojiwala industrial estate, Sachin palsana road', 'Surat', '394230', 'Gujarat[24]', '9374723041', '', '24AWJPC2715K1ZQ');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Shree Multiplast', 'Ichhapore', 'Surat', '394510', 'Gujarat[24]', '9824277737', '', '24ABMPW9170C1ZC');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('BRAHM POLY PLAST', 'Hindva Dreams, Plot No f/9, Gaypagala Road, Dhoran Pardi, Kamrej', 'Surat', '394180', 'Gujarat[24]', '8460353844', '', '24AAXFB3144P1ZW');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Dharam Plastic', 'Plot 8, Shivshankar society, B/H Surat Mercantile bank, Udhna', 'Surat', '395002', 'Gujarat[24]', '9879344246', '9825641549', '24BGWPP0388M1ZJ');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('IDEAL TECHNOPLAST INDUSTRIES LTD', 'PLOT NO. 1 TO 4 AND 78 TO 81, BLOCK NO.572 AND 572/B MADHAV INDUSTRIAL ', 'SURAT', '394540', 'Gujarat[24]', '9898506409', '', '24AAHC14073R1Z1');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('ALM Plastic', '41A, Shivshankar Society opp Bharat Petrolium', 'Surat', '395010', 'Gujarat[24]', '9879344246', '9825641549', '24ARMPP5262E1ZP');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('GEOTEX TEXTILE PVT LTD', 'BLOCK NO.57, PLOT NO.A/1/1, A2/1, PIPODARA, VILL-PIPODARA, TAL-MANGROL', 'SURAT', '394110', 'Gujarat[24]', '9374719025', '', '24AADCG3888Q1ZW');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Ganesh Corporation Awar', 'A 1 5240, GIDC, Estate, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '9328386186', '9979770775', '24AADFG4369B1ZR');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SHREE RAJESHWARI PLASTECH PVT LTD', '1 FLOOR GROUND, 1, 2 PLOT NO-32, 33 RJD INTERGRATED TEXTILE PARK ICHCHHAPOR SHREE LAXMI SALES AGENCY CHORYASHI ', 'SURAT', '394510', 'Gujarat[24]', '9824277737', '', '24AADFG4369B1ZR');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Arihant Poly Containers', 'R.S No 70/2, 70/3, 70/4, Block No 54, Nandesari Crossing, N.H 48, village-Fajalpur', 'Vadodara', '391340', 'Gujarat[24]', '7283911234', '7600011234', '24AAPFA2356L1Z9');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Dy.Conservator of forest, Anand', 'Nayab Van sarakshak kacheri, dy.Conservator of forest, jeela seva sadan, room no : 123, 124, borsad chokadi', 'Anand', '388001', 'Gujarat[24]', '9722121240', '', '24AAAGD0260J1D5');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('DEPUTY CONSERVATOR OF FOREST (Bharuch)', '0, KANBIVAGA GHB, NEAR PWD', 'Bharuch', '392001', 'Gujarat[24]', '9925116565', '', '24AAAGD1304FIZA');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('KRISHI KISHAN AGRO MULCH PVT. LTD', 'PLOT NO 318, HORIZON INDUSTRIAL PARK, NH-08, BAMANGAM, KARJAN, POR', 'Vadodara', '391240', 'Gujarat[24]', '9028158396', '9974401482', '24AAVCA3819R1ZV');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('RUBEXCO PVT LTD', '314-317, LOTUS ELITE, NR GOTRI JAKATNAKA', 'VADODARA', '390021', 'Gujarat[24]', '9925017268', '6351895618', '24AAACR8757J1Z0');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('ANIKET POLYMERS PRIVATE LIMITED', 'TF-3, Tanishq Commercial Hub, Near Manisha Circle, Old Padra Road', 'Vadodara', '390007', 'Gujarat[24]', '9586871224', '', '24AAMCA5296M1Z3');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('PRAKASH TELESERVICES PVT LTD', 'STATOS" STATIONERY & OFFICE SUPPLIES, ISHWAR KRUPA, OPP. SAFFRON TOWER FATEH GUNJ ', 'BARODA', '390002', 'Gujarat[24]', '0265-2787349', '9924755093', '24AADCP5598C1ZD');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Deputy Conservator of Forests Vyara', 'Nayab van sanrakshak shri, vyara', 'tapi', '394650', 'Gujarat[24]', '02626-222019', '9327566822', '24AAALD0173D1ZU');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('FILTER MACHINES PVT. LTD.', 'PLOT NO.2, SURVEY NO.244/251/253/851, VRAJ INDUSTRIAL PARK, OPP. LOW PRICE APPARTMENT, CANAL ROAD, MORAI', 'Vapi', '396191', 'Gujarat[24]', '9825142753', '9898057505', '24AAACF9930F1ZS');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('BREECH ORALCARE PVT. LTD', 'CREATIVE INDUSTRIAL ESTATE CCIE, GORWA ROAD, B/H. GANDHI OIL MILL COMPOUND', 'Vadodara', '390016', 'Gujarat[24]', '9586774999', '', '24AADCB1750G125');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('ARHAM POLYLINK PVT LTD', 'Plot No D-2/E-25, galendra, B/H signode india ltd, vagara, dahej sir', 'Bharuch', '392130', 'Gujarat[24]', '9054861984', '', '24AAZCA6535G1ZB');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('MARUTI BLOW TECH PRIVATE LIMITED', 'PLOT NO. C-1/4727/2, OPP. OLD RALLIS, GIDC ESTATE, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '8866242660', '', '24AAICM9893N1ZI');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SHRI JALA PACKAGING', 'PLOT NO 97, PHASE-1, GIDC, NARMADA NAGAR', 'Bharuch', '392015', 'Gujarat[24]', '9624401132', '', '24ADFPM4570M1ZA');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Govardhan Polyplast PVT LTD', 'Block No 305, Plot No 2 to 7, Village Karanj, Taluka Mandvi', 'Vadodara', '394110', 'Gujarat[24]', '9825109453', '', '24AACCG5121D1ZA');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Omkar Polyfab', 'Plot No 403, GIDC, Panoli', 'Bharuch', '394115', 'Gujarat[24]', '9227177663', '', '24AAHFO7230K1Z6');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Krishna Plastic IND', 'C-1-150, GIDC Phase-2, Narmada Nagar', 'Bharuch', '392015', 'Gujarat[24]', '9824376528', '9033932824', '24AAIFK1717E1ZQ');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('MAYUR PLASTIC INDUSTRIES', 'PLOT NO. A2/4005, A1/4008, BHARUCH, AND A1/4007, GIDC, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '9825434191', '9227177662', '24ABQFM9148L1ZI');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('AUTOTECH NON-WOVENS PVT LTD', 'PLOT NO : 37, 37-A, 38, 38-A, Autotech non-wovens pvt ltd, Pairdeal Textile Park, Mahuvej TA, Mangrol', 'Surat', '394125', 'Gujarat[24]', '9925465338', '', '24AAACW5241J1ZE');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Range Forest Officer shree, Ahwa East(one sadan)', 'Taluko Ahwa', 'Dang', '394710', 'Gujarat[24]', '9427307169', '9979564416', '24SRTDO1280G1DP');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Pragati Polyking', 'Block No 4b Ratnakar Developer, Por', 'Vadodara', '391243', 'Gujarat[24]', '9624060477', '', '24AATFP1476E1Z2');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SAMKIN TREASURE MOLDERS PVT LTD', 'Plot No-611 and 614 GIDC Estate, Ankleshwar', 'Bharuch', '393002', 'Gujarat[24]', '7043739211', '9327918696', '24ABDCS8842F1Z9');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Supreme Polymers', 'Plot NO. 247/23, GIDC Pandesara', 'Surat', '394221', 'Gujarat[24]', '9825128735', '9913852699', '24AIGPG2475H1ZF');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('NILAYKRISHNA IND PVT LTD', 'Block No:84, Plot No:7172 Mota Borsara, Aakash Industrial', 'Surat', '394110', 'Gujarat[24]', '9998513682', '6371368687', '24AAHCN5858R1ZL');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Nayabh Van Suraksak Shri Valsad North', 'Jill Sevasadan 2, First Floor', 'Valsad', '396001', 'Gujarat[24]', '9879061139', '02632-2541151', '24AAAGD0318R1ZH');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('R.F.O (Nayabh Van Surakshak Kacheri Narmada Van Vibhaag Rajpipla)', 'Near Variya Jakatnaka statue of unity road, Rajpipla', 'Narmada', '393145', 'Gujarat[24]', '9427131699', '', '24AAAGD1395N1DJ');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('NYS CHEMTRADE PRIVATE LIMITED', 'FIRST FLOOR, 14, NIRAV COMPLEX, NEAR NAVRANG HIGH SCHOOL, NARANPURA', 'Ahmedabad', '380014', 'Gujarat[24]', '7016811303', '9725503644', '24AABCM4295P1ZZ');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SHREE LAXMI INDUSTIRES', 'GROUND FLOOR, R.S.N132, BLOCK NO. 127, PLOT NO. 58', 'SURAT', '394185', 'Gujarat[24]', '7041161521', '8866893546', '24AEUFS8045P1Z0');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Tumi Enterprise Pvt Ltd', 'C-7, TULSI AVENUE, NR TULSI HOTEL, ASLALI', 'AHMEDABAD', '382427', 'Gujarat[24]', '8488834941', '9725555632', '24AAGCT0937J1ZA');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('TRIBHUVAN POLYMERS PRIVATE LIMITED', 'BLOCK NO. 63, NEAR NH 8, VILLAGE MAKHINGA', 'Surat', '394315', 'Gujarat[24]', '9687697350', '7359096354', '24AAFCT4592G1Z7');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Atlantis Products Pvt Ltd', '1208, 1209, 1210, 1214 GIDC, Dholka', 'Ahmedabad', '', 'Gujarat[24]', '9909503544', '8488834941', '24AAHCA6869P1ZX');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('GUJARAT INDUSTRIES', 'C-1-148/6, GIDC INDUSTRIAL ESTATE, PHASE II NARMADA NAGAR, BHOLAV', 'Bharuch', '392015', 'Gujarat[24]', '9825041821', '9825026954', '24ABCPN9476C1ZM');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Deputy conservator of forest Surat forest division (Normal)', 'Forest Rest House, Beside CHC, Mandvi Road Zankhvav Ta.Mangrol', 'Surat', '394440', 'Gujarat[24]', '9726085266', '9662341778', '');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('Raj Plastic Industries', '121/1, Opp G P C B Office, GIDC Estate ', 'Bharuch', '392001', 'Gujarat[24]', '9909502988', '', '24ABOPM3320Q1ZB');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('ANAND PETROCHEM PVT.LTD.', 'Floor No.: 7th, Flat No.: 703, Name Of Building: Addore Aspire, Road: University Road', 'Ahmedabad', '380015', 'Gujarat[24]', '7016811303', '9725503644', '24AADCA7659K1ZD');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('RATHNA PACKAGING INDIA PRIVATE LTD', 'PLOT NO: A AND B, BLOCK NO: 100, OFF SHREEJI WEIGH BRIDGE, BESIDE RPA MOTA, BORASARA', 'Surat', '394110', 'Gujarat[24]', '8008220888608', '', '24AADCR2300J1ZU');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('NOVO PACK', 'OPP. LUPIN LTD, GROUND FLOOR, PAIKI BUILDING, NO. F PLOT NO. 132/A GIDC INDUSTRIAL ESTATE', 'Bharuch', '393001', 'Gujarat[24]', '9375675255', '', '24AAUFN9962C1ZS');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SIDDHESHWAR POLYPACK', '5 LS NO 556, PL 29, GIDC MAIN ROAD, JITALI, ANKLESHWAR', 'Bharuch', '393002', 'Gujarat[24]', '8128462450', '', '24BVFPR3552R2ZW');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('INFINITE FOAM PVT LTD', 'PLOT NO 2017, GIDC, HALOL 2, Halol', 'PANCHMAHAL ', '389350', 'Gujarat[24]', '8487825556', '9558963833', '24AAGCI8473A1ZP');
INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no) VALUES ('SINGHAL INDUSTRIES', 'PLOT NO 401, GIDC, Halol', 'PANCHMAHAL ', '389350', 'Gujarat[24]', '9537325155', '', '24BALPA5358R1Z7');


-- Statement table (used for CA report)
CREATE TABLE IF NOT EXISTS statement_table (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_id INTEGER,
  company_name TEXT,
  bill_no TEXT,
  bill_date TEXT,
  gst_no TEXT,
  amount REAL
);