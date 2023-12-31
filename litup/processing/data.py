import json
from typing import Dict, List

from quaterion.dataset.similarity_samples import SimilarityPairSample
from torch.utils.data import Dataset


class QADataset(Dataset):
    """Dataset class to process .jsonl files with FAQ from popular cloud providers."""

    def __init__(self, dataset_path):
        self.dataset: List[Dict[str, str]] = self.read_dataset(dataset_path)

    def __getitem__(self, index) -> SimilarityPairSample:
        line = self.dataset[index]
        question = line["question"]
        # All questions have a unique subgroup
        # Meaning that all other answers are considered negative pairs
        subgroup = hash(question)
        return SimilarityPairSample(obj_a=question, obj_b=line["answer"], score=1, subgroup=subgroup)

    def __len__(self):
        return len(self.dataset)

    @staticmethod
    def read_dataset(dataset_path) -> List[Dict[str, str]]:
        """Read jsonl-file into a memory."""
        with open(dataset_path, "r") as fd:
            return [json.loads(json_line) for json_line in fd]


__all__ = ["QADataset"]
