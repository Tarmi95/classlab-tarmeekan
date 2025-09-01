import "./App.css";
import Confetti from "./Confetti";

const shareMessage = "Vive conteneur, vive Docker !";
const shareLink = "https://docker.com/";

const App = () => {
  return (
    <div className="App">
      <Confetti />
      <header className="App-header">
        <h1 style={{ marginBottom: "0px" }}>Félicitations!!!</h1>
        <p style={{ marginTop: "10px", marginBottom: "50px" }}>
          Vous avez réussi à lancer votre conteneur Docker !
        </p>
        <div>
          {/* 
          <a
            target="_blank"
            href={
              "https://www.linkedin.com/sharing/share-offsite/?url=" + shareLink
            }
            class="fa-brands fa-linkedin"
            rel="noopener noreferrer"
          >
            {" "}
          </a>
          */}
        </div>
      </header>
    </div>
  );
};

export default App;
