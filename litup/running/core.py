import pytorch_lightning as pl
import torch
from quaterion import Quaterion
from quaterion.dataset import PairsSimilarityDataLoader

from litup.processing.data import QADataset


class GT1Runner:
    def __init__(self, model):
        self.model = model

    def train(self, train_path, valid_path, params, **kwargs):
        num_gpus = params.get("cuda", torch.cuda.is_available())

        trainer = pl.Trainer(
            min_epochs=params.get("min_epochs", 1),
            max_epochs=params.get("max_epochs", 500),
            auto_select_gpus=int(num_gpus),
            log_every_n_steps=1,
        )

        train_dataset = QADataset(train_path)
        val_dataset = QADataset(valid_path)
        train_loader = PairsSimilarityDataLoader(train_dataset, batch_size=1024)
        valid_loader = PairsSimilarityDataLoader(val_dataset, batch_size=1024)

        Quaterion.fit(self.model, trainer, train_loader, valid_loader)
