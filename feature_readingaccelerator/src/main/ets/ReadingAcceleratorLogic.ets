import { ArcButtonOptions, prompt } from "@kit.ArkUI";

@Observed
export class ReadingAcceleratorLogic{


  @Track startLabel:string = 'Start';
  @Track bottomOptions: ArcButtonOptions = new ArcButtonOptions({});
  @Track topOptions: ArcButtonOptions = new ArcButtonOptions({});
  @Track scroller: Scroller = new Scroller();

  @Track text: string[] = [
    'Technology continues to shape the way people interact, work, and learn in today\'s world. With rapid advancements in artificial intelligence, communication has become faster and more efficient, making it possible to connect with others across the globe instantly. While technology offers many conveniences, it also raises important questions about privacy, security, and the impact on daily life. As new innovations emerge, society faces both exciting opportunities and unique challenges, emphasizing the importance of adapting to a constantly changing environment.',
    'Education is undergoing a transformative period, driven by digital tools and evolving learning methodologies. Online platforms and virtual classrooms now offer unprecedented access to knowledge, transcending geographical barriers and traditional schedules. This shift allows for personalized learning paths, catering to diverse student needs and paces. However, it also demands critical thinking about digital literacy, equitable access to technology, and the enduring role of human connection in the learning process. As educational landscapes continue to evolve, adaptability and innovation will be crucial for preparing individuals for tomorrow\'s complex world.',
    'Climate change represents one of the most pressing challenges facing humanity today, profoundly altering ecosystems and human societies worldwide. Rising global temperatures contribute to extreme weather events, sea-level rise, and significant biodiversity loss, impacting vulnerable communities disproportionately. Addressing this crisis requires a global concerted effort, focusing on sustainable energy solutions, reduced carbon emissions, and innovative conservation strategies. While the scale of the problem is immense, collective action and a commitment to environmental stewardship offer hope for a more resilient and sustainable future. Our ability to adapt and mitigate these changes will define the health of our planet for generations to come.',
    'Healthcare is experiencing a revolutionary transformation, largely influenced by technological breakthroughs and a deeper understanding of human biology. Personalized medicine, genetic therapies, and advanced diagnostic tools are enabling more precise and effective treatments, moving beyond conventional one-size-fits-all approaches. The integration of AI and data analytics promises to optimize patient care, streamline operations, and accelerate medical research. Yet, these advancements also bring complex ethical dilemmas regarding data privacy, accessibility of cutting-edge treatments, and the cost of innovation. Navigating this evolving landscape requires a balance between technological progress and ensuring equitable, patient-centered care for all.',
    'Smart cities are emerging as innovative urban centers, leveraging technology to enhance livability, sustainability, and efficiency for their residents. Interconnected sensors, advanced data analytics, and intelligent infrastructure optimize everything from traffic flow and public transport to waste management and energy consumption. This integration aims to create more responsive and resilient urban environments, improving the quality of life for citizens. However, the development of smart cities also brings challenges related to data security, surveillance concerns, and ensuring that technological advancements benefit all socioeconomic groups. Balancing innovation with privacy and inclusivity is paramount for building truly intelligent and equitable urban futures.',
    'Cultural exchange plays a vital role in fostering global understanding and promoting peaceful coexistence in an increasingly interconnected world. Through shared experiences in arts, language, food, and traditions, individuals gain new perspectives and challenge preconceived notions about different societies. This interaction enriches personal growth, cultivates empathy, and builds bridges between diverse communities, breaking down barriers and reducing stereotypes. While globalization can sometimes lead to cultural homogenization, deliberate efforts at exchange ensure the preservation of unique identities and the celebration of diversity. Embracing and facilitating these exchanges are essential for building a more harmonious and interconnected global society.'
  ]
  @Track words: string[] = [];
  @Track currentWordIndex: number = -1;
  @Track isStarted: boolean = false;
  @Track timer: number = 0;
  @Track yoffset: number = 0;

  startReading() {
    if (this.isStarted) {
      this.topOptions.label = 'Start'
      return;
    }

    this.isStarted = true;
    this.currentWordIndex = 0;
    this.topOptions.label = 'Reading...'

    this.timer = setInterval(() => {
      if (this.currentWordIndex < this.words.length - 1) {
        this.currentWordIndex += 1;
        this.scrollToCurrentWord();
      } else {
        clearInterval(this.timer);
        this.isStarted = false;
        prompt.showToast({ message: 'Read Completed!' });
        this.topOptions.label = 'Start'
      }
    }, 300);
  }

  stopReading() {
    clearInterval(this.timer);
    this.isStarted = false;
    this.topOptions.label = 'Start'
  }




  changeName() {
    this.startReading()
  }
  scrollToCurrentWord() {

    this.scroller.scrollTo({
      xOffset: 0,
      yOffset: this.yoffset += 3,
      animation: {
        duration: 300,
        curve: Curve.EaseOut
      }
    });
  }
}