(function() {

  var app = angular.module('app');

  // create new controller HomeController w/ homeController constructor
  app.controller('HomeController', [
    '$scope',
    '$http',
    '$sce',
    '$window',
    '$document',
    function($scope, $http, $sce, $window, $document) {
      $scope.welcome = "Welcome home";

      var LAT_CONF = 42.337748;
      var LONG_CONF = -71.085369;
      var LAT_NWK = 42.336729;
      var LONG_NWK = -71.091747;
      var DATE_CONF = new Date("April 6, 2019 11:00:00");

      $scope.modalVisible = false;
      $scope.modalSpeakerBioParagraphs = [];

      $scope.toggleModal = function(speaker) {
          if (speaker.bioParagraphs && speaker.bioParagraphs.length) {
            $scope.modalSpeaker= speaker;
            $scope.modalVisible = true;
          }
      };

      $scope.hideModal = function() {
        $scope.modalVisible = false;
      }

      /* Google Maps */
      var mapOptions = {
        zoom: 15,
        center: new google.maps.LatLng(LAT_CONF, LONG_CONF),
        mapTypeId: google.maps.MapTypeId.TERRAIN
      };

      $scope.markerConference = new google.maps.Marker({
        position: {lat: LAT_CONF, lng: LONG_CONF},
        title: 'Speaker Conference'
      });

      $scope.markerNetworking = new google.maps.Marker({
        position: {lat: LAT_NWK, lng: LONG_NWK},
        title: 'Alumni Panel & Networking Night'
      });

      $scope.map = new google.maps.Map(document.getElementById('map'), mapOptions);
      $scope.markerConference.setMap($scope.map);
      $scope.markerNetworking.setMap($scope.map);

      $scope.hideButton = false;

      $scope.getTimeLeftMessage = function() {
        var endDate = DATE_CONF.getTime() / 1000,
            now = Date.now() / 1000,
            message;

        // returns # days between now and the conference date
        var dayDiff = function(d1,d2) {
  	       return (d1 - d2) / (24 * 60 * 60);
        };

        if (dayDiff(endDate, now) > 2) {
  	        message = "More details to come";
  	         $scope.hideButton = true;
  	    }
        else if (endDate > now) {
          message = "Only " + Math.floor((endDate - now) / 3600) + " hours left to register! Additional tickets will be sold at door on Saturday.";
        } else {
          $scope.hideButton = true;
          message = "Online registration has ended. Additional tickets will be sold at door on Saturday.";
        }
        return message;
      };

      $scope.menuItems = ['About', 'Speakers', 'Schedule', 'Location', 'FAQ',
      'Sponsors', 'Press Releases', 'Past Speakers', 'Selected Presentations', 'Management Committee',
      'Advisory Board', 'Contact'];

      $scope.nav = {};
      $scope.nav.img = "/public/assets/img/nav-logo.png";

      // scroll variables
      var scrollOffset = 30;
      var scrollDuration = 2000;

      // the auto scroll function
      $scope.jump = function(section) {
        var target = angular.element(document.getElementById(section));
        $document.scrollToElement(target, scrollOffset, scrollDuration);
      };

      $scope.scrollTo = function(section) {

        // bring up nav dropdown
        $scope.toggleBurger();
        var dropDown = document.getElementById('drop-menu');
        dropDown.style.height = 0;

        var elName = section.toLowerCase().replace(" ", "-");

        var target = angular.element(document.getElementById(elName));
        $document.scrollToElement(target, scrollOffset, scrollDuration);
      };

        $scope.intro = {};
        $scope.intro.img = "/public/assets/img/intro-logo.png";

        $scope.about = {};
        $scope.about.title = "About";
        $scope.about.summary1 = "CAIS is a student-run organization that enables students and professionals to learn from and engage with experts in the alternative investments space. Its mission is to bridge the gap between the traditional educational curriculum and real-life application by creating a knowledge-sharing forum for like-minded students and professionals to interact. CAIS educates students on topics related to private equity, venture capital, hedge funds and real estate.";
        $scope.about.summary2 = "CAIS 2019 will be held on April 5-6, 2019. It will mark the seventh anniversary of the inaugural CAIS event, and will highlight the strides CAIS has made since its inception. It begins with a networking event designed to provide attendees with thoughtful discussion led by a panel of recent Northeastern alumni who are currently working in alternative investments. The main event, held the following day, consists of a series of speakers and panels. Speakers and panelists have had years of extensive experience in the alternative investments space and are considered specialists in their respective fields.";


        $scope.speakers = [
          {
            'category': 'Keynotes',
            'members': [
              {
                name: "William Cohan",
                img: "/public/assets/img/speakers/headshots/williamcohan.jpg",
                topic: "A Partner's Perspective in Venture Capital",
                year: "",
                title: "Author",
                company: "New York Times",
                keynote: true,
                bioParagraphs: ["William D. Cohan, a former senior Wall Street M&A investment banker for 17 years at Lazard Frères & Co., Merrill Lynch and JPMorganChase, is the New York Times bestselling author of three non-fiction narratives about Wall Street: “Money and Power: How Goldman Sachs Came to Rule the World”; “House of Cards: A Tale of Hubris and Wretched Excess on Wall Street”; and, “The Last Tycoons: The Secret History of Lazard Frères & Co.”, the winner of the 2007 FT/Goldman Sachs Business Book of the Year Award. His book, “The Price of Silence”, about the Duke lacrosse scandal was published in April 2014 and was also a New York Times bestseller. His new book, “Why Wall Street Matters”, was published by Random House in February 2017. He is a special correspondent at Vanity Fair and a columnist for the DealBook section of the New York Times. He also writes for The Financial Times, The New York Times, Bloomberg BusinessWeek, The Atlantic, The Nation, Fortune,and Politico. He previously wrote a bi-weekly opinion column for The New York Times and an opinion column for BloombergView. He also appears regularly on CNN, on Bloomberg TV, where he is a contributing editor, on MSNBC and the BBC-TV. He has also appeared three times as a guest on the Daily Show, with Jon Stewart, The NewsHour, The Charlie Rose Show, The Tavis Smiley Show, and CBS This Morning as well as on numerous NPR, BBC and Bloomberg radio programs.",
                    "He is a graduate of Phillips Academy, Duke University, Columbia University School of Journalism and the Columbia University Graduate School of Business."
                  ]
              },
              {
                name: "Rudina Seseri",
                img: "/public/assets/img/speakers/headshots/rudinaseseri.jpg",
                topic: "",
                year: "",
                title: "Founder and Managing Partner",
                company: "Glasswing Ventures",
                keynote: true,
                modalShown: false,
                bioParagraphs: ["Rudina Seseri is Founder and Managing Partner of Glasswing Ventures, an early-stage venture capital firm dedicated to investing in the next generation of AI-powered technology companies. With over 17 years of investing and transactional experience, Rudina has led technology investments and acquisitions in startup companies in enterprise SaaS, IT software and data, marketing technologies and robotics. Rudina’s portfolio of investments include AUTIT, Celtra, CHAOSSEARCH, CrowdTwist, Inrupt, Plannuh, SocialFlow, Talla and Zylotech. Rudina is a Harvard Business School Rock Venture Capital Partner and Entrepreneur-In-Residence, serving for 5 consecutive years. She is also a Member of the Business Leadership Council of Wellesley College.",
                    "Rudina serves as a member of the advisory board for GSK Consumer and the Philanthropy Board for Boston Children’s Hospital. She has been named a 2017 Boston Business Journal Power 50: Newsmaker, a 2014 Women to Watch honoree by Mass High Tech and a 2011 Boston Business Journal 40-under-40 honoree for her professional accomplishments and community involvement. She graduated magna cum laude from Wellesley College with a BA in Economics and International Relations and with an MBA from the Harvard Business School (HBS). She is a member of Phi Beta Kappa and Omicron Delta Epsilon honor societies."
                ]
              }
          ]
      },
      {
        'category': 'Defining Impact Investing',
        'members': [
          {
            name: "Mark Bernfeld",
            img: "/public/assets/img/speakers/headshots/markbernfeld.jpg",
            topic: "",
            year: "",
            title: "Professor",
            company: "Northeastern University",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Professor Mark Bernfeld is a Lecturer in Entrepreneurship and Finance at Northeastern University. He also serves as a Member of Clean Energy Venture Group and is an angel investor with a commitment to environmentally and socially responsible businesses. Mr. Bernfeld founded Tamarack Technologies in 1993 with the vision of meeting growing need to conserve energy and improve air quality in homes. He remains owner and Board Chairman, where he continues to advocate for Tamarack’s mission to promote the reemergence of home cooling using outdoor air, and to make accessible to homeowners sensible solutions to the problem of unhealthy indoor air. Mr. Bernfeld has 35 years of experience in the insurance industry, with diverse roles from consultant to broker to insurance company executive. He is a member in and active angel investor with Launchpad Venture Group, which provides funding and advice to early-stage companies. He serves on the Board of Pearl’s Premium Lawn Seed, provider of environmentally friendly, low maintenance grass seed. Mark also oversees a family real estate business and is a board member at Community Legal Services and Counseling Center (CLSACC), a Cambridge, Massachusetts based nonprofit that provides free legal assistance and affordable psychological counseling to help combat the effects of poverty and violence. Mark received an MBA from the Wharton School at the University of Pennsylvania and a BS in Mathematics from Dartmouth College."
            ]
          },
          {
            name: "Mitali Prasad",
            img: "/public/assets/img/speakers/headshots/mitaliprasad.png",
            topic: "",
            year: "",
            title: "ESG Equity Analyst",
            company: "Trillium Asset Management",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Mitali is a Research Analyst covering the Industrials and Materials sectors. Prior to joining Trillium in 2016, she was a Portfolio Manager and Equity Analyst at Washington Capital Management where she covered multiple industry sectors as well as managed MID and SMID GARP portfolios. Before joining Washington Capital Management, Mitali was a Portfolio Manager at OFI Institutional Asset Management, a subsidiary of Oppenheimer Funds/Mass Mutual. She moved to OFI Institutional from Babson Capital Management where she was an Equity Analyst/Portfolio Manager on their small and mid-cap portfolios.",
              "Mitali began her career in equity analysis as an intern at Trillium while she was studying at Columbia University. She is a Chartered Financial Analyst (CFA) charterholder and a member of the CFA Institute and the CFA Society Boston, serving on its SRI committee from 2008 – 2010 and as Chair of its Value Investing committee from 2009-2013.",
              "Mitali holds a Bachelor of Electronics and Telecommunications Engineering from the Delhi Institute of Technology in New Delhi, India and a Master of International Affairs with a Major in Finance from Columbia University in New York. She holds an M.B.A. from the Indian Institute of Management in Bangalore, India."
            ]
          },
          {
            name: "Mark Watson",
            img: "/public/assets/img/speakers/headshots/markwatson.png",
            topic: "",
            year: "",
            title: "Managing Director",
            company: "Boston Impact Initiative Fund",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Mark serves as Managing Director of the Boston Impact Initiative Fund, which offers blended capital to address the racial wealth gap in Eastern Massachusetts. He is also the founder of Keel Asset Management LLC, a financial advisory firm that provides socially responsible financial planning and investment advisory services to nonprofits, public and corporation pension plans. Mark is an investment committee member of the Fair Food Fund; chair of the Triskeles Foundation’s Asset Management Committee; board president of Sustainable Cape, Inc.; and a former board member of the Social Venture Network.",
              "A native of Chicago, Mr. Watson holds a MBA '92 with a concentration in finance from the University of Chicago. He graduated from the University of Illinois at Champaign in 1985 with a B.S. of Finance.   He is member of US/SIF; an Overseer of the Museum of Fine Arts-Boston and Chair of The Highlands Center in Truro, MA."
            ]
          },
          {
            name: "Anthony Eames",
            img: "/public/assets/img/speakers/headshots/anthonyeames.jpg",
            topic: "",
            year: "",
            title: "Director of Responsible Investment Strategy",
            company: "Eaton Vance",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
                "Anthony Eames is a vice president of Eaton Vance Management and director of responsible investment strategy. He is responsible for Eaton Vance’s suite of strategies focused on responsible investing, encompassing actively and passively managed U.S. and international equity strategies, fixed-income strategies and asset allocation funds. He is responsible for client communications and insights on investment strategy and portfolio positioning.",
                "Anthony began his career in the investment management industry in 1995, and joined Eaton Vance in 2016. Before joining Eaton Vance, he was senior vice president and national sales manager at Calvert Investment Management. Previously, he represented Calvert as senior regional vice president in the Northeast and held various roles in client services and sales.",
                "Anthony earned a B.A. from Wittenberg University. He holds the Accredited Investment Fiduciary and Accredited Asset Management Specialist designations, and FINRA Series 7, 24 and 63 licenses."
            ]
          }
        ]
      },
      {
        'category': 'Current Trends in Commodities Markets',
        'members': [
          {
            name: "William J. Kelly",
            img: "/public/assets/img/speakers/headshots/williamkelly.jpg",
            topic: "",
            year: "",
            title: "President and CEO",
            company: "CAIA",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "William (Bill) J. Kelly, CEO of the CAIA Association, is an asset management industry veteran with extensive managerial and boardroom experience gained through successive CFO, COO, CEO and Independent Board director roles. He has led both start-ups and full-scale global organizations. Bill is the former CEO of Robeco Investment Management, a subsidiary of the Netherlands-based global asset management organization with over $200 billion of assets under management, where he oversaw all aspects of United States business, including portfolio management, distribution and product development. He also was responsible for the strategic growth, introduction, and positioning of new managed products in the US and Europe, including alternative investments. Bill was a founder and former CEO of Boston Partners Asset Management, a self-funded partnership enterprise, which became one of the industry’s largest and most successful start-up money management organizations. Previous to that, he served as CFO of The Boston Company Asset Management and earlier in his career held various positions at Bear Stearns and was an auditor at PricewaterhouseCoopers."
            ]
          },
          {
            name: "David Chang",
            img: "/public/assets/img/speakers/headshots/davidchang.jpg",
            topic: "",
            year: "",
            title: "Senior MD and Commodities Portfolio Manager",
            company: "Wellington Management",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "David is a portfolio manager in Global Equity Portfolio Management on the Natural Resources Team. He manages commodity portfolios on behalf of clients, drawing on research from Wellington Management’s global industry analysts, equity portfolio managers, and team analysts. He currently manages several commodities-related approaches. David is also a member of Wellington’s Diversity Committee.",
              "David earned his BA in quantitative economics and international relations, magna cum laude, from Tufts University (2001). Additionally, he holds the Chartered Financial Analyst designation and is a member of the Boston Security Analysts Society and the CFA Institute."
            ]
          },
          {
            name: "Michael Mandell",
            img: "/public/assets/img/speakers/headshots/michaelmandell.jpg",
            topic: "",
            year: "",
            title: "Director",
            company: "Global Energy & Commodities",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "",
              ""
            ]
          }
        ]
      },
      {
        'category': 'Why Alternatives?',
        'members': [
          {
            name: "Dawn Lim",
            img: "/public/assets/img/speakers/headshots/dawnlim.png",
            topic: "",
            year: "",
            title: "Reporter",
            company: "Wall Street Journal",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Dawn Lim covers asset management for The Wall Street Journal in New York. She has also reported on pensions, endowments and private equity for the Journal and its professional newsletters.",
              "She holds a B.A in English from Cornell University and an Masters in Business and Economic Reporting from NYU."
            ]
          },
          {
            name: "Jeff Lombardi",
            img: "/public/assets/img/speakers/headshots/jefflombardi.jpg",
            topic: "",
            year: "",
            title: "International Head of Fund of Funds & Alternatives",
            company: "Itau Asset Management",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "",
              ""
            ]
          },
          {
            name: "Jennifer DeSisto",
            img: "/public/assets/img/speakers/headshots/jenniferdesisto.jpg",
            topic: "",
            year: "",
            title: "Portfolio Manager",
            company: "Anchor Capital Management",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Jennifer DeSisto, CFA, is a member of the All Cap Value and Balanced portfolio management teams and Anchor’s Investment Policy Committee, in addition to managing a segment of legacy high net worth client portfolios and relationships.",
              "Prior to Anchor Capital, Jennifer gained significant experience from the Fiduciary Trust Company in Boston, where she managed approximately $350 million of high net worth and family office assets and was a senior member of the investment committee.",
              "Jennifer holds a B.S. in Industrial Management and Economics from Carnegie Mellon University and an MBA from the MIT Sloan School of Business."
            ]
          }
        ]
      },
      {
        'category': 'Investing in Technology',
        'members': [
          {
            name: "Lex Zhao",
            img: "/public/assets/img/speakers/headshots/lexzhao.jpg",
            topic: "",
            year: "",
            title: "Senior Associate",
            company: "One Way Ventures",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Lex is a Senior Associate at One Way Ventures, a sector agnostic seed stage venture fund backing exceptional immigrant tech founders. He is an immigrant from China and previously led the operations team at Vestwell, a venture-backed fintech startup. Prior to Vestwell, Lex earned his MBA with Honors from the University of Chicago Booth School of Business. At Chicago Booth, he was as an Associate at Moderne Ventures and took part in the New Venture Challenge accelerator program.",
              "Lex started his career at Bridgewater Associates, the world’s largest hedge fund, and NERA Economic Consulting, a leading economic consultancy. Lex graduated from Cornell University where he earned his B.A. in Economics with Distinction."
            ]
          }
        ]
      },
      {
        'category': 'Investing in Real Estate',
        'members': [
          {
            name: "Jeffrey Gandel",
            img: "/public/assets/img/speakers/headshots/jeffreygandel.jpg",
            topic: "",
            year: "",
            title: "Managing Partner",
            company: "Longwharf Capital",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Jeff is a founding partner of Long Wharf and is responsible for capital raising, investor relations, and business strategy for the firm. He is also a member of Long Wharf’s investment committee and works closely with the investment and accounting teams on portfolio management and capital markets activities. Jeff has 27 years of experience in the real estate and alternative investments markets, and holds a B.A from Tufts University."
            ]
          }
        ]
      },
      {
        'category': 'Alternatives Pitch',
        'members': [
          {
            name: "Michelle Kelner",
            img: "/public/assets/img/speakers/headshots/unavailable.png",
            topic: "",
            year: "",
            title: "Senior Partner",
            company: "Sandglass Capital",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Ms. Kelner is a founder of the Sandglass Capital Management and was previously a Senior Partner and Portfolio Strategist with Prince Street Capital, a New York and Singapore based investment firm that specializes in emerging and frontier markets.",
              "At Prince Street, Ms. Kelner served on the firm’s investment committee and was responsible for investment idea generation for the firm’s portfolios. She also led the firm’s business development, including building the firm’s institutional investor base, institutionalizing internal investment and risk management processes, and developing external reporting procedures.",
              "Before joining Prince Street, Ms. Kelner spent 15 years in emerging markets as a portfolio manager and trader at hedge funds SAC Capital, Tudor Investment in New York, and Hermitage Capital in Moscow. She also spent six years as an investment banker focused on Russia and the former Soviet Union, at Unicredit in New York and UralSib Capital in Moscow.",
              "Ms. Kelner graduated with honors in finance and economics from the McIntire School of Commerce at the University of Virginia."
            ]
          }
        ]
      },
      {
        'category': 'Young Alumni Panel',
        'members': [
          {
            name: "Matthew Saitta",
            img: "/public/assets/img/speakers/headshots/matthewsaitta.jpg",
            topic: "",
            year: "",
            title: "Associate",
            company: "Providence Equity",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Matthew Saitta is an associate on the Providence Strategic Growth team and is based in their Providence office. Prior to joining Providence in 2018, he was an investment banking analyst in Morgan Stanley’s Mergers & Acquisitions group and received a Bachelor of Science in Business Administration and Psychology from Northeastern University."
            ]
          },
          {
            name: "Ryan Lee",
            img: "/public/assets/img/speakers/headshots/ryanlee.jpg",
            topic: "",
            year: "",
            title: "Analyst",
            company: "Advantage Capital",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              "Ryan Lee joined Advantage Capital in 2016 as an analyst on the investment team. He is responsible for sourcing investments and providing due diligence support. Prior to joining Advantage Capital, he worked on the strategy consulting team of Roland Berger Strategy Consultants in Beijing and on the risk team of MFS Investment Management in Boston. Ryan received his master’s degree in international management and his bachelor’s degree in international business in East Asian studies with a concentration in finance and a minor in Mandarin from Northeastern University."
            ]
          },
          {
            name: "Katie Mulligan",
            img: "/public/assets/img/speakers/headshots/katiemulligan.jpg",
            topic: "",
            year: "",
            title: "",
            company: "",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              ""
            ]
          },
          {
            name: "Tim O'Brien",
            img: "/public/assets/img/speakers/headshots/timobrien.jpg",
            topic: "",
            year: "",
            title: "Research Analyst",
            company: "Point72 Asset Management",
            keynote: false,
            modalShown: false,
            bioParagraphs: [
              ""
            ]
          }
        ]
      }
    ];
      $scope.pastSpeakers = [
            {
              name: "Bob Davis",
              img: "/public/assets/img/speakers/headshots/bobdavis.png",
              topic: "A Partner's Perspective in Venture Capital",
              year: "2018",
              title: "Partner",
              company: "Highland Capital Partners",
              bioParagraphs: ["Bob is a General Partner at Highland focusing primarily on digital media and has been with our team since 2001. He currently represents Highland with ALOHA, Beeswax, FRESHLY, Handy, Harry’s, Lovepop and SessionM. Bob previously served on the boards of Bullhorn (acquired by Vista Equity Partners), Fastclick (Nasdaq: FSTC), Going (acquired by AOL), Name Media (acquired by Endurance International Group), Navic (acquired by MSFT), nuTonomy (acquired by Delphi Automotive PLC), Pixable (acquired by SingTel), Quattro (acquired by Apple), Quigo (acquired by AOL) and Turbine (acquired by Warner Bros.)",
                  "Bob is the best-selling author of \"Speed is Life: Street Smart Lessons from the Front Lines of Business (Currency).\"",
                  "Prior to joining Highland, Bob served as the Chief Executive Officer of Terra Lycos (TRLY) formed in October 2000 with the $5.5 billion acquisition of Lycos by Telefonica’s Terra Networks of Spain. Previously, Bob was the Founder of Lycos, Inc. (LCOS) and served as its President and Chief Executive Officer since its inception in 1995 where he led Lycos from a start-up with $2 million in venture capital funding to become the most visited online destination in the world. Under his leadership, Lycos jumped from the fastest IPO in Nasdaq history, a mere nine months from inception to offering, exceeding Wall Street estimates for 22 consecutive quarters, and grew to a global media entity",
                  "Bob has also served on the boards of several public and private sector companies including John Hancock (JHFS), Ticketmaster (TCMS), Terra Lycos (TRLY), Lycos (LCOS) and Lycos Europe (LCY). He serves on the Board of Advisors for the Boston College Carroll School of Management, the Board of Governors for the CEO Club of Boston, the Chairman’s Council for Boston’s Children’s Hospital and is currently the President of The Rivers School Board of Trustees.",
                  "Bob has advised former President Clinton on matters relating to internet commerce and regulation and has addressed Congress, The United Nations, The National Press Corps and the U.S. Council of Foreign Relations on similar matters.",
                  "Bob graduated summa cum laude from Northeastern University, where he earned a B.S. in Business Administration. He holds an M.B.A. from Babson College, an Honorary Doctorate of Commercial Sciences from Bentley College, and an Honorary Doctorate from Northeastern University.",
                  "Bob has been inducted into the Academy of Distinguished Entrepreneurs and received the Massachusetts Interactive Media Council’s Lifetime Achievement Award."
                ]
            },
          {
            name: "Gerry Coughlin",
            img: "/public/assets/img/speakers/headshots/gerrycoughlin.png",
            topic: "",
            year: "2018",
            title: "Managing Partner",
            company: "Oakpoint Advisors",
            bioParagraphs: ["Gerry is founder and Managing Partner of Oakpoint Advisors. He is responsible for business development and manages Oakpoint’s strategic GP relationships. As the head of Oakpoint’s Capital Team, Gerry manages the firm’s institutional capital marketing business and oversees all aspects of capital formation.",
              "Gerry was formerly the President of Vinik Asset Management, a multi-billion dollar equity long/short fund. In that capacity, Gerry was charged with restructuring the entire infrastructure of Vinik Asset Management and ensuring the firm met all standards of \"best practices\". He was directly responsible for Finance, Marketing, Operations, Trading and Technology, as well as being one of five members of the Management Committee.",
              "Gerry spent 20 years of his career at Morgan Stanley. He joined Morgan Stanley in 1989 in the Equity Controllers group, working in New York, Tokyo, Singapore and Hong Kong. He established Morgan Stanley's equity trading and sales trading for Southeast Asia in Singapore, before moving to Hong Kong in 1999 to run regional sales trading, and ultimately assuming responsibility for Asia distribution globally. Gerry returned to New York in 2004 as a member of the Prime Brokerage Executive Committee, where he assumed responsibility for Capital Introductions and Business Consulting. In 2006, Gerry was named Global Head of Sales, where he was responsible for overall coverage of the firm's prime brokerage clients, as well as any new business.",
              "He holds a BS in Finance with honors from Northeastern University."
          ]
          },
          {
            name: "Henry Nasella",
            img: "/public/assets/img/speakers/headshots/henrynasella.jpeg",
            topic: "Different Perspectives in Private Equity",
            year: "2017",
            title: "Partner",
            company: "LNK Partners",
          },
          {
            name: "Ted English",
            img: "/public/assets/img/speakers/headshots/tedenglish.jpg",
            topic: "Different Perspectives in Private Equity",
            year: "2017",
            title: "Executive Chairman",
            company: "Bob's Discount Furniture",
          },
          {
            name: "Fran Janis",
            img: "/public/assets/img/speakers/headshots/franjanis.jpg",
            topic: "",
            year: "2017",
            title: "Founding Partner",
            company: "Pomona Capital",
          },
          {
            name: "Richard D'Amore",
            isModerator: true,
            img: "/public/assets/img/speakers/headshots/richarddamore.jpg",
            topic: "",
            year: "2017",
            title: "Partner",
            company: "North Bridge Venture Partners",
          },
          {
            name: "Alan McKim",
            img: "/public/assets/img/speakers/headshots/alanmckim.jpg",
            topic: "Investing in Sustainability",
            year: "2017",
            title: "Chairman, CEO & President",
            company: "Clean Harbors Inc."
          },
          {
            name: "Keith Black",
            img: "/public/assets/img/speakers/previous_speakers/keith-black.jpg",
            topic: "Harvard, Yale and Investments: A Post-Crisis View",
            year: "2015",
            title: "Managing Director",
            company: "CAIA Association"
          },
          {
            name: "Stephen Pagliuca",
            img: "/public/assets/img/speakers/previous_speakers/pagliuca.jpg",
            topic: "Global Outlook of Private Equity and Venture Capital",
            year: "2014",
            title: "Managing Director/Co-owner",
            company: "Bain Capital/Boston Celtics"
          },
          {
            name: "James Swanson",
            img: "/public/assets/img/speakers/previous_speakers/jswanson.png",
            topic: "The Sustainable Cycle",
            year: "2013",
            title: "Chief Investment Stategist",
            company: "MFS Investment Management"
          },
          {
            name: "Roger Ibbotson",
            img: "/public/assets/img/speakers/previous_speakers/ribbotson.jpg",
            title: "Chairman and Chief Investment Officer",
            company: "Zebra Capital Management, LLC"
          }
      ];

      $scope.schedule = {};

      $scope.schedule.friday = [
        {
          time: "5:30 PM",
          activity: "Registration",
          speaker: ""
        },
        {
          time: "6 PM",
          activity: "Welcome",
          speaker: "Dean Echambadi - Dean, DMSB\nNicholas Lara - Chairman, CAIS"
        },

        {
          time: "6:10 PM",
          activity: "Keynote Address",
          speaker: "Colby Gilbert*, CAIS\nWilliam Cohan - Author, New York Times"
        },
        {
          time: "7:10 PM",
          activity: "DMSB Young Alumni",
          speaker: "Ryan Lee - Analyst, Advantage Capital\nKatie Mulligan - Associate, Pillar VC\nTim O'Brien - Research Analyst, Point72 Asset Management\nMatthew Saitta- Associate, Providence Equity"
        },
        {
          time: "8:20 PM",
          activity: "Closing Remarks",
          speaker: "Alyssa Wren - CAIS Co-President"
        },
        {
          time: "8:30 PM",
          activity: "Networking Session",
          speaker: ""
        }
      ];

      $scope.schedule.saturday = [
        {
          time: "8:30 AM",
          activity: "Registration / Breakfast",
          speaker: ""
        },
        {
          time: "9:00 AM",
          activity: "Welcome",
          speaker: "Morrisa Clayman - CAIS Co-President"
        },
        {
          time: "9:10 AM",
          activity: "Real Estate",
          speaker: "Jeff Gandel - Partner, LongWharf Capital"
        },
        {
          time: "10:10 AM",
          activity: "Defining Impact Investing",
          speaker: "Mark Bernfeld*- Professor, Northeastern University\nMitali Prasad - ESG Equity Analysis, Trillium Asset Management\nMark Watson- MD, Boston Impact Initiative Fund\nLisa Hayles- Principal, Boston Common Asset Management\nAnthony Eames- Director of Responsible Investment Strategy, Calvert"
        },
        {
          time: "10:50 AM",
          activity: "Coffee Break",
          speaker: ""
        },
        {
          time: "11:05 AM",
          activity: "Commodities",
          speaker: "Bill Kelly* - CEO, CAIA\nDavid Chang - Portfolio Manager, Wellington Management\nMichael Mandell - Director, Natixis"
        },
        {
          time: "11:55 AM",
          activity: "Why Alternatives?",
          speaker: "Dawn Lim* - Reporter, Wall Street Journal\nJeff Lombardi - Int'l Head of Fund of Funds & Alternatives, Itau USA AM\nJennifer DeSisto - Portfolio Manager, Anchor Capital Advisors"
        },
        {
          time: "12:50 PM",
          activity: "Lunch",
          speaker: ""
        },
        {
          time: "1:45 PM",
          activity: "Keynote Address",
          speaker: "Rudina Seseri- Founder, Glasswing Capital"
        },
        {
          time: "2:35 PM",
          activity: "Investing in Technology",
          speaker: "Lex Zhao- Senior Associate, One Way Ventures\nVivjan Myrto- Founder & Managing Partner, Hyperplane VC"
        },
        {
          time: "3:25 PM",
          activity: "Alternatives Pitch",
          speaker: "Michelle Kelner - Senior Partner, Sandglass Capital Management"
        },
        {
          time: "4:15 PM",
          activity: "Closing Remarks",
          speaker: "Alyssa Wren - CAIS Co-President"
        },
        {
          time: "4:20 PM",
          activity: "Networking Session",
          speaker: ""
        }
      ];

      $scope.faqs = [
        {
          question: "Who can attend?",
          answer: "CAIS 2019 is open to anyone interested in learning more about alternative investments, regardless of university or professional affiliation."
        },
        {
          question: "What's the cost?",
          answer: "CAIS 2019 will employ a variable cost structure. An early bird special will be available until Saturday, March 23rd. These tickets will cost $30 each, and will grant the attendee access to Alumni Night and the Conference. Beginning Sunday, March 24th, each ticket will cost $40, and will grant the attendee access to Alumni Night and the Conference. The registration fee includes breakfast and lunch at the Conference on April 6th."
        },
        {
          question: "What's the dresscode?",
          answer: "Business formal is recommended."
        },
        {
          question: "What is Alumni Night?",
          answer: "Alumni Night consists on an Alumni Panel and a Keynote Speaker. The Alumni Panel will be structured as Q&A session where Northeastern Alumni working in the alternatives space can share their experiences, advice, and insights into their respective fields. Following the panel, the Keynote Speaker and Moderator will host a fireside chat. These two distinguished professionals will discuss their experiences and will then field questions directly from the audience. Overall, Alumni Night is a great opportunity for students to build their Northeastern network, particularly in the competitive alternatives field, and learn how some of our top talent broke into the industry."
        },
        {
          question: "Do I have to attend both the alumni panel and the conference?",
          answer: "Attendees are free to participate in either event, though we highly recommend coming to both for the best experience."
        },
        {
          question: "Is the press allowed to attend?",
          answer: "As a general practice, we do not invite press to our conference events. CAIS 2019 will operate under Chatham House Rules in order to preserve the substance of the conference. Chatham House Rules are defined as a meeting where participants are free to use the information received, but neither the identity nor the affiliation of the speakers, nor that of any participant, may be revealed."
        },
      ];

      /*
       * YouTube vids of selected presentations
       */

      $scope.presentations = [
        {
          url: $sce.trustAsResourceUrl("https://www.youtube.com/embed/c6OCuycMmRg"),
          description: ""
        },
        {
          url: $sce.trustAsResourceUrl("https://www.youtube.com/embed/byoSuIUhjsg"),
          description: "Pagliuca"
        },
        {
          url: $sce.trustAsResourceUrl("https://www.youtube.com/embed/uvFvArULZKY"),
          description: ""
        }
      ];

      $scope.team = [
        {
          name: "Alyssa Wren",
          img: "/public/assets/img/team/alyssawren.png",
          linkedin: "https://www.linkedin.com/in/alyssa-wren-736075b4/",
          title: "Co-President"
        },
        {
          name: "Morrisa Clayman",
          img: "/public/assets/img/team/morrisaclayman.png",
          linkedin: "https://www.linkedin.com/in/morrisa-clayman/",
          title: "Co-President"
        },
        {
          name: "Colby Gilbert",
          img: "/public/assets/img/team/codygilbert.png",
          linkedin: "https://www.linkedin.com/in/gilbertrichardc/",
          title: ""
        },
        {
          name: "Angela Hourihan",
          img: "/public/assets/img/team/angelahourihan.png",
          linkedin: "https://www.linkedin.com/in/angelahourihan/",
          title: ""
        },
        {
          name: "Gustaf Palm",
          img: "/public/assets/img/team/gustafpalm.png",
          linkedin: "https://www.linkedin.com/in/gustaf-palm-567bb2155/",
          title: ""
        },
        {
          name: "Matt McLaughlin",
          img: "/public/assets/img/team/mattmclaughlin.png",
          linkedin: "https://www.linkedin.com/in/mattfmclaughlin/",
          title: ""
        },
        {
          name: "Miracle Olatunji",
          img: "/public/assets/img/team/miracleolatunji.png",
          linkedin: "https://www.linkedin.com/in/miracleolatunji/",
          title: ""
        }
      ];

      /*
       * Advisory Board
       */
       $scope.advisoryBoard = [
         {
           name: "Nicholas Lara",
           img: "/public/assets/img/advisory/lara.jpg",
           linkedin: "https://www.linkedin.com/pub/nicholas-f-lara/2a/ba7/47b",
           title: "Founder and Chairman"
         },
         {
           name: "Lauren Tawfik",
           img: "/public/assets/img/team/laurentawfik.jpg",
           linkedin: "https://www.linkedin.com/in/lauren-tawfik-a93a48111?authType=name&authToken=jiE_&trk=prof-sb-browse_map-name"
         },
         {
           name: "Michael Counihan",
           img: "/public/assets/img/advisory/michaelcounihan.jpg",
           linkedin: "https://www.linkedin.com/in/michaelbcounihan/"
         },
         {
           name: "Stephen Price",
           img: "/public/assets/img/advisory/price.jpg",
           linkedin: "https://www.linkedin.com/in/stephenprice93"
         },
         {
           name: "Kimberly Krzemien",
           img: "/public/assets/img/advisory/kimberlykrzemien.png",
           linkedin: "https://www.linkedin.com/in/kimberlykrzemien/"
         },
         {
           name: "Rohit Malrani",
           img: "/public/assets/img/advisory/rohit.jpg",
           linkedin: "https://www.linkedin.com/in/rohitmalrani"
         },
         {
           name: "Amy Zhou",
           img: "/public/assets/img/advisory/amyzhou.jpg",
           linkedin: "https://www.linkedin.com/in/amywzhou/"
         },
         {
           name: "Daniel Asulin",
           img: "/public/assets/img/advisory/asulin.jpg",
           linkedin: "https://www.linkedin.com/in/danielgasulin"
         },
         {
           name: "Rohan Venkatesh",
           img: "/public/assets/img/advisory/rohanvenkatesh.jpg",
           linkedin: "https://www.linkedin.com/in/rohanvenkatesh"
         },
         {
           name: "Jake Fulton",
           img: "/public/assets/img/advisory/jakefulton.jpg",
           linkedin: "https://www.linkedin.com/pub/jake-fulton/43/a29/641"
         }
       ];

       var pressImgRoot = "/public/assets/img/press/";

       $scope.press = [
         {
           link: "http://www.businesswire.com/news/home/20170320005109/en/Northeastern-University-Host-5th-Annual-Collegiate-Alternative",
           img: pressImgRoot + "businesswire.jpg",
           paddingTop: false,
           extraPadding: false
         },
         {
           link: "https://sg.finance.yahoo.com/news/northeastern-university-host-5th-annual-110000963.html",
           img: pressImgRoot + "yahoofinance.png",
           paddingTop: false,
           extraPadding: false
         }
       ];

      var imgRoot = "/public/assets/img/sponsors/";

      $scope.sponsors = [
        {'category': 'Platinum Sponsors',
          'members': [{
            name: "Thrive",
            img: imgRoot + "thrive.jpg",
            title: "Platinum Sponsor",
            link: "http://www.northeastern.edu/cfi"
        }]
      },
      {
        'category': 'Gold Sponsors',
        'members': [{
                  name: "General Catalyst",
                  img: imgRoot + "generalcatalyst.png",
                  title: "Gold Sponsor",
                  link: "http://generalcatalyst.com/"
                },
                {
                  name: "UBS",
                  img: imgRoot + "ubs.png",
                  title: "Gold Sponsor",
                  link: "https://www.ubs.com/us/en.html"
                }]
      },
      {
        'category': 'Silver Sponsors',
        'members': [
          {
            name: "EY",
            img: imgRoot + "ey.png",
            title: "Silver Sponsor",
            link: ""
          },
                {
                  name: "CFA Society Boston",
                  img: imgRoot + "cfaboston.jpg",
                  title: "Silver Sponsor",
                  link: "https://www.cfaboston.org/"
                },
                {
                          name: "CAIA",
                          img: imgRoot + "caia.jpg",
                          title: "Silver Sponsor",
                          link: "https://www.caia.org/"
                        }
                      ]
      },
      {
        'category': 'Media & Data Sponsors',
        'members': [
              {
                name: "Wall Street Oasis",
                img: imgRoot + 'wso.png',
                hasFacts: true,
                link: "http://www.wallstreetoasis.com/"
              }]
      }
      ];

      $scope.affiliates = [
        {
          name: "Alt Assets",
          img: imgRoot + "altassets.jpg"
        },
        {
          name: "Northeastern Finance and Investment Club",
          img: imgRoot + "nufic-color.png"
        },
        {
          name: "Northeastern Alumni Development Association",
          img: imgRoot + "nuada-color.png"
        },
        {
          name: "LSE SU Alternative Investments Conference",
          img: imgRoot + "lse-aic-color.png"
        }
      ];

      // scroll "logic"

      // set initial
      $scope.scrollPosition = 0;
      $scope.animate = {
        about: false,
        speakers: false,
        faq: false,
        team: false,
        sponsors: false,
        contact: false
      };

      $scope.anAbout = false;
      $scope.anAboutPoints = false;
      $scope.anSpeakers = false;
      $scope.anSpeakerPics = false;
      $scope.anSchedule = false;
      $scope.anSchedulePics = false;
      $scope.anFaq = false;
      $scope.anFaqs = false;
      $scope.anPastSpeakers = false;
      $scope.anPastSpeakersPics = false;
      $scope.anPresentations = false;
      $scope.anVids = false;
      $scope.anTeam = false;
      $scope.anTeamPics = false;
      $scope.anAvisory = false;
      $scope.anAdvisoryPics = false;
      $scope.anSponsors = false;
      $scope.anContact = false;

      var sections = document.getElementsByTagName('section');

      // get elements as angular elements and ignore the first section (intro section)
      // var ngSections = sections.map(angular.element).slice(1,sections.length);



      var aboutEl = angular.element(document.getElementById("about"));
      var speakersEl = angular.element(document.getElementById("speakers"));
      var scheduleEl = angular.element(document.getElementById("schedule"));
      var faqEl = angular.element(document.getElementById("faq"));
      var pastSpeakersEl = angular.element(document.getElementById("past-speakers"));
      var teamEl = angular.element(document.getElementById("management-committee"));
      var presentationsEl = angular.element(document.getElementById("selected-presentations"));
      var advisoryEl = angular.element(document.getElementById("advisory-board"));
      var sponsorsEl = angular.element(document.getElementById("sponsors"));
      var contactEl = angular.element(document.getElementById("contact"));

      angular.element($window).bind("scroll", function() {

         if (this.pageYOffset > aboutEl.prop('offsetTop') - 100) {
             $scope.isScrolling = true;
         } else {
             $scope.isScrolling = false;
         }

         if (this.pageYOffset > aboutEl.prop('offsetTop') - 1000) {
            $scope.anAbout = true;
         }
         if (this.pageYOffset > aboutEl.prop('offsetTop') - 900) {
            $scope.anAboutPoints = true;
         }
         if (this.pageYOffset > speakersEl.prop('offsetTop') - 1000) {
           $scope.anSpeakers = true;
         }
         if (this.pageYOffset > speakersEl.prop('offsetTop') - 750) {
           $scope.anSpeakerPics = true;
         }
         if (this.pageYOffset > scheduleEl.prop('offsetTop') - 1000) {
           $scope.anSchedule = true;
         }
         if (this.pageYOffset > scheduleEl.prop('offsetTop') - 750) {
           $scope.anScheduleChart = true;
         }
         if (this.pageYOffset > faqEl.prop('offsetTop') - 1000) {
           $scope.anFaq = true;
         }
         if (this.pageYOffset > faqEl.prop('offsetTop') - 750) {
           $scope.anFaqs = true;
         }
         if (this.pageYOffset > pastSpeakersEl.prop('offsetTop') - 1000) {
           $scope.anPastSpeakers = true;
         }
         if (this.pageYOffset > pastSpeakersEl.prop('offsetTop') - 750) {
           $scope.anPastSpeakersPics = true;
         }
         if (this.pageYOffset > presentationsEl.prop('offsetTop') - 1000) {
           $scope.anPresentations = true;
         }
         if (this.pageYOffset > presentationsEl.prop('offsetTop') - 750) {
           $scope.anVids = true;
         }
         if (this.pageYOffset > teamEl.prop('offsetTop')  - 1000) {
           $scope.anTeam = true;
         }
         if (this.pageYOffset > teamEl.prop('offsetTop')  - 750) {
           $scope.anTeamPics = true;
         }
         if (this.pageYOffset > advisoryEl.prop('offsetTop')  - 1000) {
           $scope.anAdvisory = true;
         }
         if (this.pageYOffset > advisoryEl.prop('offsetTop')  - 750) {
           $scope.anAdvisoryPics = true;
         }
         if (this.pageYOffset > sponsorsEl.prop('offsetTop') - 1000) {
           $scope.anSponsors = true;
         }

         $scope.$apply();
     });

     }
  ]);

}());
