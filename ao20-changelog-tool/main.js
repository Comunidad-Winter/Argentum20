require("dotenv").config();

const prompt = require("prompt");
const fs = require("fs");
const axios = require("axios");

const trelloKey = process.env.TRELLO_KEY;
const trelloToken = process.env.TRELLO_TOKEN;

const authParams = `key=${trelloKey}&token=${trelloToken}`;

const getList = async (listName) => {
  try {
    const lists = (await axios.get(`https://api.trello.com/1/boards/1wFsgh3M/lists/all?${authParams}`)).data;

    const list = lists.filter((list) => list.name.includes(listName))[0];

    if (!list) {
      throw Error;
    }

    return list;
  } catch (e) {
    console.log(`No se ha encontrado una lista que tenga en su título "${listName}".`);
    process.exit(1);
  }
};

const writeChangelog = async () => {
  prompt.start();
  const { patchNumber } = await prompt.get({
    properties: {
      patchNumber: {
        description: "Ingrese el número de parche (ej: 0.18.0)",
      },
    },
  });

  const list = await getList(patchNumber);
  const cards = (await axios.get(`https://api.trello.com/1/lists/${list.id}/cards?${authParams}`)).data;

  const fileName = `${patchNumber}.txt`;
  const path = `./changelogs/${fileName}`;

  const tasks = cards.map((card) => ({ title: card.name, desc: card.desc.length < 500 ? card.desc : "" }));
  if (!tasks.length) {
    throw new Error(`El parche ${patchNumber} no tiene ninguna tarea resuelta.`);
  }

  fs.writeFile(path, "", () => {});
  const logger = fs.createWriteStream(path, {
    flags: "a",
  });

  tasks.forEach((task) => {
    if (task.desc) {
      logger.write(`- ${task.title}: ${task.desc}\n`);
    } else {
      logger.write(`- ${task.title}\n`);
    }
  });

  console.log(`Changelog guardado en ${path}`);
};

writeChangelog();
